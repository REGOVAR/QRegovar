#include "eventslistmodel.h"
#include "Model/regovar.h"

EventsListModel::EventsListModel(QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Date);

}



EventsListModel::EventsListModel(QString target, QString id, QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Date);

    QJsonObject body;
    body.insert(target, id);

    Request* req = Request::post(QString("/events"), QJsonDocument(body).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadJson(json["data"].toArray());
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}



bool EventsListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mEventList.clear();
    for (const QJsonValue& eventJson: json)
    {
        QJsonObject eventData = eventJson.toObject();
        Event* event = regovar->eventsManager()->getOrCreateEvent(eventData["id"].toInt());
        event->fromJson(eventData);
        if (!mEventList.contains(event)) mEventList.append(event);
    }
    endResetModel();
    emit countChanged();
    return true;
}



bool EventsListModel::add(Event* event)
{
    if (!mEventList.contains(event))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mEventList.append(event);
        endInsertRows();
        emit countChanged();
    }
}



bool EventsListModel::refresh()
{

}



int EventsListModel::rowCount(const QModelIndex&) const
{
    return mEventList.count();
}



QVariant EventsListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mEventList.count())
        return QVariant();

    const Event* event= mEventList[index.row()];
    if (role == Message || role == Qt::DisplayRole)
        return event->message();
    else if (role == Id)
        return event->id();
    else if (role == Type)
        return event->type();
    else if (role == Date)
        return event->date();
    else if (role == Author && event->author() != nullptr)
        return event->author()->firstname() + " " + event->author()->lastname();
    else if (role == Details)
        return event->details();
    else if (role == SearchField)
        return event->searchField();
    return QVariant();
}



QHash<int, QByteArray> EventsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Message] = "message";
    roles[Details] = "details";
    roles[Type] = "type";
    roles[Date] = "date";
    roles[Author] = "author";
    roles[SearchField] = "searchField";
    return roles;
}

