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

Subject* PhenotypesListModel::subject() const
{
    if (mSubjectId == -1) return  nullptr;
    return regovar->subjectsManager()->getOrCreateSubject(mSubjectId);
}

void PhenotypesListModel::clear()
{
    beginResetModel();
    mHpoDataList.clear();
    endResetModel();
    emit countChanged();
}

bool PhenotypesListModel::fromJson(QJsonArray json)
{
    beginResetModel();
    mHpoDataList.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        HpoData* hpo = regovar->phenotypesManager()->getOrCreate(data["id"].toString());
        hpo->fromJson(data);
        mHpoDataList.append(hpo);
    }
    endResetModel();
    emit countChanged();
    return true;
}

bool PhenotypesListModel::add(HpoData* hpodata)
{
    if (hpodata!= nullptr && !mHpoDataList.contains(hpodata))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mHpoDataList.append(hpodata);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool PhenotypesListModel::remove(HpoData* hpoData)
{
    if (mHpoDataList.contains(hpoData))
    {
        int pos = mHpoDataList.indexOf(hpoData);
        beginRemoveRows(QModelIndex(), pos, pos);
        mHpoDataList.removeAll(hpoData);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}

HpoData* PhenotypesListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mHpoDataList.count())
    {
        return mHpoDataList[idx];
    }
    return nullptr;
}

int PhenotypesListModel::rowCount(const QModelIndex&) const
{
    return mHpoDataList.count();
}

QVariant PhenotypesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mHpoDataList.count())
        return QVariant();

    const HpoData* hpo = mHpoDataList[index.row()];
    if (hpo == nullptr) // TODO: why sometime pheno is nullptr ? how could it append
        return QVariant();
    if (role == Label || role == Qt::DisplayRole)
        return hpo->label();
    else if (role == Id)
        return hpo->id();
    else if (role == Type)
        return hpo->type();
    else if (role == Category)
        return hpo->category();
    else if (role == DiseasesScore)
        return hpo->diseasesFreq();
    else if (role == GenesScore)
        return hpo->genesFreq();
    else if (role == Genes)
        return hpo->genes().join(", ");
    else if (role == Presence && mSubjectId != -1)
        return regovar->subjectsManager()->getOrCreateSubject(mSubjectId)->presence(hpo->id());
    else if (role == AdditionDate && mSubjectId != -1)
        return regovar->subjectsManager()->getOrCreateSubject(mSubjectId)->additionDate(hpo->id());
    else if (role == SearchField)
        return hpo->searchField();

    return QVariant();
}

QHash<int, QByteArray> PhenotypesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Label] = "label";
    roles[Type] = "type";
    roles[Category] = "category";
    roles[Presence] = "presence";
    roles[AdditionDate] = "additionDate";
    roles[DiseasesScore] = "diseasesScore";
    roles[GenesScore] = "genesScore";
    roles[SearchField] = "searchField";
    return roles;
}
