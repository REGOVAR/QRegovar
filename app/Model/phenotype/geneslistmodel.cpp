#include "geneslistmodel.h"
#include "Model/regovar.h"

GenesListModel::GenesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Id);
}


void GenesListModel::clear()
{
    beginResetModel();
    mGenes.clear();
    endResetModel();
    emit countChanged();
}

bool GenesListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mGenes.clear();
    for(const QJsonValue& val: json)
    {
        QString gene = val.toString();
        if (!gene.isEmpty() && !mGenes.contains(gene))
        {
            mGenes.append(gene);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool GenesListModel::append(QString gene)
{
    if (!gene.isEmpty() && !mGenes.contains(gene))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mGenes.append(gene);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool GenesListModel::remove(QString gene)
{
    if (mGenes.contains(gene))
    {
        int pos = mGenes.indexOf(gene);
        beginRemoveRows(QModelIndex(), pos, pos);
        mGenes.removeAll(gene);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

QString GenesListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mGenes.count())
    {
        return mGenes[idx];
    }
    return nullptr;
}

QString GenesListModel::join(QString separator)
{
    return mGenes.join(separator);
}


int GenesListModel::rowCount(const QModelIndex&) const
{
    return mGenes.count();
}

QVariant GenesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mGenes.count())
        return QVariant();

    const QString gene = mGenes[index.row()];
    if (role == Id || role == Qt::DisplayRole)
        return gene;
    else if (role == Panel)
        return ""; // TODO: regovar->panelsManager()->findPanelsWith(gene)
    else if (role == SearchField)
        return gene; // TODO + panel

    return QVariant();
}

QHash<int, QByteArray> GenesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Panel] = "panel";
    roles[SearchField] = "searchField";
    return roles;
}
