#include "hpodatalistmodel.h"
#include "Model/regovar.h"

HpoDataListModel::HpoDataListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Label);
}

HpoDataListModel::HpoDataListModel(int subjectId, QObject* parent) : HpoDataListModel(parent)
{
    mSubjectId = subjectId;
}

Subject* HpoDataListModel::subject() const
{
    if (mSubjectId == -1) return  nullptr;
    return regovar->subjectsManager()->getOrCreateSubject(mSubjectId);
}

void HpoDataListModel::clear()
{
    beginResetModel();
    mHpoDataList.clear();
    endResetModel();
    emit countChanged();
}

bool HpoDataListModel::fromJson(QJsonArray json)
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

bool HpoDataListModel::add(HpoData* hpodata)
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

bool HpoDataListModel::remove(HpoData* hpoData)
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

HpoData* HpoDataListModel::getAt(int idx)
{
    if (idx >= 0 && idx <= mHpoDataList.count())
    {
        return mHpoDataList[idx];
    }
    return nullptr;
}

int HpoDataListModel::rowCount(const QModelIndex&) const
{
    return mHpoDataList.count();
}

QVariant HpoDataListModel::data(const QModelIndex& index, int role) const
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
    else if (role == DiseasesFreq)
        return hpo->diseasesFreq()["label"].toString();
    else if (role == GenesFreq)
        return hpo->genesFreq()["label"].toString();
    else if (role == Genes)
        return hpo->genes()->join(", ");
    else if (role == Presence && mSubjectId != -1)
        return regovar->subjectsManager()->getOrCreateSubject(mSubjectId)->presence(hpo->id()) == "present" ? true: false;
    else if (role == AdditionDate && mSubjectId != -1)
        return regovar->subjectsManager()->getOrCreateSubject(mSubjectId)->additionDate(hpo->id());
    else if (role == SearchField)
        return hpo->searchField();

    return QVariant();
}

QHash<int, QByteArray> HpoDataListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Label] = "label";
    roles[Type] = "type";
    roles[Category] = "category";
    roles[Presence] = "presence";
    roles[AdditionDate] = "additionDate";
    roles[DiseasesFreq] = "diseasesFreq";
    roles[GenesFreq] = "genesFreq";
    roles[Genes] = "genes";
    roles[SearchField] = "searchField";
    return roles;
}
