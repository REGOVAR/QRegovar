#include "panelentrieslistmodel.h"

PanelEntriesListModel::PanelEntriesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Label);
}



void PanelEntriesListModel::clear()
{
    beginResetModel();
    mPanelEntriesList.clear();
    endResetModel();
    emit countChanged();
}

bool PanelEntriesListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mPanelEntriesList.clear();
    for(const QJsonValue& val: json)
    {
        mPanelEntriesList.append(new PanelEntry(val.toObject()));
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool PanelEntriesListModel::append(PanelEntry* entry)
{
    if (entry!= nullptr)
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPanelEntriesList.append(entry);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PanelEntriesListModel::remove(PanelEntry* entry)
{
    if (mPanelEntriesList.contains(entry))
    {
        int pos = mPanelEntriesList.indexOf(entry);
        beginRemoveRows(QModelIndex(), pos, pos);
        mPanelEntriesList.removeAll(entry);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PanelEntriesListModel::removeAt(int idx)
{
    if (idx >= 0 && idx <= mPanelEntriesList.count())
    {
        beginRemoveRows(QModelIndex(), idx, idx);
        mPanelEntriesList.removeAt(idx);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

PanelEntry* PanelEntriesListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mPanelEntriesList.count())
    {
        return mPanelEntriesList[idx];
    }
    return nullptr;
}

int PanelEntriesListModel::rowCount(const QModelIndex&) const
{
    return mPanelEntriesList.count();
}

QVariant PanelEntriesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mPanelEntriesList.count())
        return QVariant();

    const PanelEntry* entry = mPanelEntriesList[index.row()];
    if (entry == nullptr)
        return QVariant();
    if (role == Label || role == Qt::DisplayRole)
        return entry->label();
    else if (role == Type)
        return entry->type();
    else if (role == Details)
        return entry->details();
    else if (role == SearchField)
        return entry->searchField();

    return QVariant();
}

QHash<int, QByteArray> PanelEntriesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Label] = "label";
    roles[Type] = "type";
    roles[Details] = "details";
    roles[SearchField] = "searchField";
    return roles;
}
