#include "geneslistmodel.h"
#include "Model/regovar.h"

GenesListModel::GenesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Symbol);
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
        Gene* gene = regovar->phenotypesManager()->getGene(val.toString());
        if (!gene->symbol().isEmpty() && !mGenes.contains(gene))
        {
            mGenes.append(gene);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool GenesListModel::append(Gene* gene)
{
    if (gene != nullptr && !mGenes.contains(gene))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mGenes.append(gene);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool GenesListModel::remove(Gene* gene)
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

Gene* GenesListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mGenes.count())
    {
        return mGenes[idx];
    }
    return nullptr;
}

QString GenesListModel::join(QString separator)
{
    QString result;
    for(Gene* gene: mGenes)
    {
        result += gene->symbol() +  separator;
    }
    return result.mid(0, result.length() - separator.length());
}


int GenesListModel::rowCount(const QModelIndex&) const
{
    return mGenes.count();
}

QVariant GenesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mGenes.count())
        return QVariant();

    const Gene* gene = mGenes[index.row()];
    if (role == Symbol || role == Qt::DisplayRole)
        return gene->symbol();
    else if (role == Panels)
        return ""; // TODO: regovar->panelsManager()->findPanelsWith(gene)
    else if (role == SearchField)
        return gene->searchField(); // TODO + panel

    return QVariant();
}

QHash<int, QByteArray> GenesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Symbol] = "symbol";
    roles[Panels] = "panels";
    roles[SearchField] = "searchField";
    return roles;
}
