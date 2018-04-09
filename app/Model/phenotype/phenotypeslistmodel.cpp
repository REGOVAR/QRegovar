#include "phenotypeslistmodel.h"
#include "Model/regovar.h"

PhenotypesListModel::PhenotypesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Label);
}

PhenotypesListModel::PhenotypesListModel(int subjectId, QObject* parent) : PhenotypesListModel(parent)
{
    mSubjectId = subjectId;
}



void PhenotypesListModel::clear()
{
    beginResetModel();
    mPhenotypes.clear();
    endResetModel();
    emit countChanged();
}


bool PhenotypesListModel::fromJson(QJsonArray json)
{
    beginResetModel();
    mPhenotypes.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        Phenotype* pheno = regovar->phenotypesManager()->getOrCreatePhenotype(data["id"].toString());
        pheno->fromJson(data);
        mPhenotypes.append(pheno);
    }
    endResetModel();
    emit countChanged();
    return true;
}


bool PhenotypesListModel::add(Phenotype* pheno)
{
    if (pheno!= nullptr && !mPhenotypes.contains(pheno))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPhenotypes.append(pheno);
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


    const Phenotype* pheno = mPhenotypes[index.row()];
    if (pheno == nullptr) // TODO: why sometime pheno is nullptr ? how could it append
        return QVariant();
    if (role == Label || role == Qt::DisplayRole)
        return pheno->label();
    else if (role == Id)
        return pheno->id();
    else if (role == Definition)
        return pheno->definition();
    else if (role == Parent && pheno->parent() != nullptr)
        return pheno->parent()->label();
//    else if (role == Childs)
//        return "";
//    else if (role == Diseases)
//        return "";
    else if (role == Presence && mSubjectId != -1)
        return pheno->presence(mSubjectId);
    else if (role == Genes)
        return pheno->genes().join(", ");
    else if (role == SearchField)
        return pheno->searchField();
    return QVariant();
}

QHash<int, QByteArray> PhenotypesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Label] = "label";
    roles[Definition] = "definition";
    roles[Parent] = "parent";
    roles[Childs] = "childs";
    roles[Diseases] = "diseases";
    roles[Genes] = "genes";
    roles[Presence] = "presence";
    roles[SearchField] = "searchField";
    return roles;
}
