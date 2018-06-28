#include "phenotypeslistmodel.h"
#include "phenotype.h"
#include "Model/regovar.h"

PhenotypesListModel::PhenotypesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Label);
}


void PhenotypesListModel::clear()
{
    beginResetModel();
    mPhenotypes.clear();
    endResetModel();
    emit countChanged();
}

bool PhenotypesListModel::loadJson(const QJsonArray& json)
{
    beginResetModel();
    mPhenotypes.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        HpoData* hpo = regovar->phenotypesManager()->getOrCreate(data["id"].toString());
        hpo->loadJson(data);
        mPhenotypes.append((Phenotype*)hpo);
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool PhenotypesListModel::append(Phenotype* phenotype)
{
    if (phenotype!= nullptr && !mPhenotypes.contains(phenotype))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPhenotypes.append(phenotype);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PhenotypesListModel::remove(Phenotype* phenotype)
{
    if (mPhenotypes.contains(phenotype))
    {
        int pos = mPhenotypes.indexOf(phenotype);
        beginRemoveRows(QModelIndex(), pos, pos);
        mPhenotypes.removeAll(phenotype);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

Phenotype* PhenotypesListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mPhenotypes.count())
    {
        return mPhenotypes[idx];
    }
    return nullptr;
}

int PhenotypesListModel::rowCount(const QModelIndex&) const
{
    return mPhenotypes.count();
}

QVariant PhenotypesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mPhenotypes.count())
        return QVariant();

    const Phenotype* hpo = mPhenotypes[index.row()];
    if (role == Label || role == Qt::DisplayRole)
        return hpo->label();
    else if (role == Id)
        return hpo->id();
    else if (role == Qualifiers && !mDiseaseId.isEmpty())
        return hpo->qualifier(mDiseaseId);
    else if (role == SearchField)
        return hpo->searchField();

    return QVariant();
}

QHash<int, QByteArray> PhenotypesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Label] = "label";
    roles[Qualifiers] = "qualifiers";
    roles[SearchField] = "searchField";
    return roles;
}
