#include "panelslistmodel.h"
#include "Model/regovar.h"

PanelsListModel::PanelsListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}


void PanelsListModel::clear()
{
    beginResetModel();
    mPanels.clear();
    endResetModel();
    emit countChanged();
}

bool PanelsListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mPanels.clear();
    for(const QJsonValue& val: json)
    {
        PanelVersion* panel = regovar->panelsManager()->getPanelVersion(val.toString());
        if (panel != nullptr)
        {
            mPanels.append(panel);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool PanelsListModel::append(PanelVersion* panel)
{
    if (panel != nullptr && !mPanels.contains(panel))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPanels.append(panel);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PanelsListModel::remove(PanelVersion* panel)
{
    if (mPanels.contains(panel))
    {
        int pos = mPanels.indexOf(panel);
        beginRemoveRows(QModelIndex(), pos, pos);
        mPanels.removeAll(panel);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

PanelVersion* PanelsListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mPanels.count())
    {
        return mPanels[idx];
    }
    return nullptr;
}

QString PanelsListModel::join(QString separator)
{
    QString result;
    for(PanelVersion* panel: mPanels)
    {
        result += panel->fullname() + separator;
    }
    return result.mid(0, result.length() - separator.length());
}


int PanelsListModel::rowCount(const QModelIndex&) const
{
    return mPanels.count();
}

QVariant PanelsListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mPanels.count())
        return QVariant();

    const PanelVersion* panel = mPanels[index.row()];
    if (role == Name || role == Qt::DisplayRole)
        return panel->fullname();
    else if (role == Id)
        return panel->id();
    else if (role == Comment)
        return panel->comment();
    else if (role == CreationDate)
        return panel->createDate().toString("yyyy-MM-dd HH:mm");
    else if (role == SearchField)
        return panel->searchField();

    return QVariant();
}

QHash<int, QByteArray> PanelsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[CreationDate] = "creationDate";
    roles[SearchField] = "searchField";
    return roles;
}

