#include "diseaseslistmodel.h"
#include "Model/regovar.h"

DiseasesListModel::DiseasesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Label);
}


void DiseasesListModel::clear()
{
    beginResetModel();
    mDiseases.clear();
    endResetModel();
    emit countChanged();
}

bool DiseasesListModel::loadJson(const QJsonArray& json)
{
    beginResetModel();
    mDiseases.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        HpoData* hpo = regovar->phenotypesManager()->getOrCreate(data["id"].toString());
        hpo->loadJson(data);
        mDiseases.append((Disease*)hpo);
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool DiseasesListModel::append(Disease* disease)
{
    if (disease!= nullptr && !mDiseases.contains(disease))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mDiseases.append(disease);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool DiseasesListModel::remove(Disease* disease)
{
    if (mDiseases.contains(disease))
    {
        int pos = mDiseases.indexOf(disease);
        beginRemoveRows(QModelIndex(), pos, pos);
        mDiseases.removeAll(disease);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

Disease* DiseasesListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mDiseases.count())
    {
        return mDiseases[idx];
    }
    return nullptr;
}

int DiseasesListModel::rowCount(const QModelIndex&) const
{
    return mDiseases.count();
}

QVariant DiseasesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mDiseases.count())
        return QVariant();

    const Disease* hpo = mDiseases[index.row()];
    if (role == Label || role == Qt::DisplayRole)
        return hpo->label();
    else if (role == Id)
        return hpo->id();
    else if (role == Qualifiers && !mPhenotypeId.isEmpty())
    {
        Phenotype* pheno = (Phenotype*)regovar->phenotypesManager()->getOrCreate(mPhenotypeId);
        return pheno->qualifier(hpo->id());
    }
    else if (role == SearchField)
        return hpo->searchField();

    return QVariant();
}

QHash<int, QByteArray> DiseasesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Label] = "label";
    roles[Qualifiers] = "qualifiers";
    roles[SearchField] = "searchField";
    return roles;
}
