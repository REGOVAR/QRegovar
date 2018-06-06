#include "jsonlistmodel.h"

JsonListModel::JsonListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}


void JsonListModel::clear()
{
    beginResetModel();
    mJson.clear();
    endResetModel();
    emit countChanged();
}

bool JsonListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mJson.clear();
    for(const QJsonValue& val: json)
    {
        mJson.append(val.toObject());
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool JsonListModel::append(QJsonObject json)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mJson.append(json);
    endInsertRows();
    emit countChanged();
    return true;
}

bool JsonListModel::remove(QJsonObject)
{
    // TODO
//    if (mJson.contains(gene))
//    {
//        int pos = mJson.indexOf(gene);
//        beginRemoveRows(QModelIndex(), pos, pos);
//        mJson.removeAll(gene);
//        endRemoveRows();
//        emit countChanged();
//        return true;
//    }
    return false;
}

QJsonObject JsonListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mJson.count())
    {
        return mJson[idx];
    }
    return QJsonObject();
}

QString JsonListModel::join(QString separator, QString key)
{
    QString result;
    for(QJsonObject json: mJson)
    {
        result += json.value(key).toString() + separator;
    }
    return result.mid(0, result.length() - separator.length());
}


int JsonListModel::rowCount(const QModelIndex&) const
{
    return mJson.count();
}

QVariant JsonListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mJson.count())
        return QVariant();

    const QJsonObject json = mJson[index.row()];
    if (role == Name || role == Qt::DisplayRole)
    {
        if (json.contains("name")) return json["name"];
        else if (json.contains("label")) return json["label"];
        else if (json.contains("title")) return json["title"];
        else if (json.contains("symbol")) return json["symbol"];
    }
    else if (role == Id)
    {
        if (json.contains("id")) return json["id"];
        else if (json.contains("uid")) return json["uid"];
        else if (json.contains("hpo_id")) return json["hpo_id"];
    }
    else if (role == Comment)
    {
        if (json.contains("comment")) return json["comment"];
        else if (json.contains("description")) return json["description"];
        else if (json.contains("details")) return json["details"];
    }
    else if (role == Json)
    {
        return json;
    }
    else if (role == SearchField)
    {
        QString searchField = "";
        for(QString key: json.keys())
        {
            searchField += json[key].toString() + " ";
        }
        return searchField;
    }

    return QVariant();
}

QHash<int, QByteArray> JsonListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[SearchField] = "searchField";
    return roles;
}
