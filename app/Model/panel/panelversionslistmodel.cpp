#include "panelversionslistmodel.h"
#include "panelversion.h"
#include "panel.h"

PanelVersionsListModel::PanelVersionsListModel(Panel* root): QAbstractListModel(root)
{
    mRootPanel = root;
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Order);
}



void PanelVersionsListModel::clear()
{
    beginResetModel();
    mPanelVersionsList.clear();
    endResetModel();
    emit countChanged();
}

bool PanelVersionsListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mPanelVersionsList.clear();
    for(const QJsonValue& val: json)
    {
        mPanelVersionsList.append(new PanelVersion(mRootPanel, val.toObject()));
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool PanelVersionsListModel::append(PanelVersion* version)
{
    if (version!= nullptr && !mPanelVersionsList.contains(version))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPanelVersionsList.append(version);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PanelVersionsListModel::remove(PanelVersion* version)
{
    if (mPanelVersionsList.contains(version))
    {
        int pos = mPanelVersionsList.indexOf(version);
        beginRemoveRows(QModelIndex(), pos, pos);
        mPanelVersionsList.removeAll(version);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PanelVersionsListModel::removeAt(int idx)
{
    if (idx >= 0 && idx <= mPanelVersionsList.count())
    {
        mPanelVersionsList.removeAt(idx);
        return true;
    }
    return false;
}

PanelVersion* PanelVersionsListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mPanelVersionsList.count())
    {
        return mPanelVersionsList[idx];
    }
    return nullptr;
}




PanelVersion* PanelVersionsListModel::addVersion(QJsonObject data, bool append)
{
    // If not exists, create it
    if (data.contains("id") && !mVersionsMap.contains(data["id"].toString()))
    {
        PanelVersion* version = new PanelVersion(this);
        version->loadJson(data);
        mVersionsMap.insert(version->id(), version);
        if (append)
        {
            mPanelVersionsList.append(version);
        }
        else
        {
            mPanelVersionsList.insert(0, version);
        }
        return version;
    }
    // If already exists, get it, load json and return
    PanelVersion* version = mVersionsMap[data["id"].toString()];
    version->loadJson(data);
    return version;
}

PanelVersion* PanelVersionsListModel::addVersion(PanelVersion* version)
{
    if (version != nullptr && !mVersionsMap.contains(version->id()))
    {
        mVersionsMap.insert(version->id(), version);
        mPanelVersionsList.append(version);
    }
    return version;
}


PanelVersion* PanelVersionsListModel::headVersion()
{
    if (mPanelVersionsList.count() > 0)
    {
        return mPanelVersionsList.first();
    }
    return nullptr;
}




int PanelVersionsListModel::rowCount(const QModelIndex&) const
{
    return mPanelVersionsList.count();
}

QVariant PanelVersionsListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mPanelVersionsList.count())
        return QVariant();

    const PanelVersion* version = mPanelVersionsList[index.row()];
    if (version == nullptr)
        return QVariant();
    if (role == Name || role == Qt::DisplayRole)
        return version->name();
    else if (role == Id)
        return version->id();
    else if (role == Order)
        return version->order();
    else if (role == Comment)
        return version->comment();
    else if (role == CreationDate)
        return version->createDate();
    else if (role == UpdateDate)
        return version->updateDate();
    else if (role == SearchField)
        return version->searchField();

    return QVariant();
}

QHash<int, QByteArray> PanelVersionsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Order] = "order";
    roles[Name] = "name";
    roles[Comment] = "comment";
    roles[CreationDate] = "creationDate";
    roles[UpdateDate] = "updateDate";
    roles[SearchField] = "searchField";
    return roles;
}
