#include "sampleslistmodel.h"
#include "Model/regovar.h"

SamplesListModel::SamplesListModel(QObject* parent): QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}


void SamplesListModel::clear()
{
    beginResetModel();
    mSamples.clear();
    endResetModel();
    emit countChanged();
}


bool SamplesListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mSamples.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        Sample* sample = regovar->samplesManager()->getOrCreateSample(data["id"].toInt());
        sample->loadJson(data, false);
        mSamples.append(sample);
    }
    endResetModel();
    emit countChanged();
    return true;
}


bool SamplesListModel::append(Sample* sample)
{
    if (sample!= nullptr && !mSamples.contains(sample))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mSamples.append(sample);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool SamplesListModel::remove(Sample* sample)
{
    if (mSamples.contains(sample))
    {
        int pos = mSamples.indexOf(sample);
        beginRemoveRows(QModelIndex(), pos, pos);
        mSamples.removeAll(sample);
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}


Sample* SamplesListModel::getAt(int idx)
{
    if (idx >=0 && idx<mSamples.count())
    {
        return mSamples[idx];
    }
    return nullptr;
}


int SamplesListModel::rowCount(const QModelIndex&) const
{
    return mSamples.count();
}


QVariant SamplesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mSamples.count())
        return QVariant();

    Sample* sample = mSamples[index.row()];
    if (role == Name || role == Qt::DisplayRole)
        return sample->name();
    else if (role == Id)
        return sample->id();
    else if (role == IsMosaic)
        return sample->isMosaic();
    else if (role == Status)
        return sample->statusUI();
    else if (role == Comment)
        return sample->comment();
    else if (role == Source)
        return sample->sourceUI();
    else if (role == Reference)
        return sample->reference()->name();
    else if (role == UpdateDate)
        return sample->updateDate().toString("yyyy-MM-dd HH:mm");
    else if (role == SearchField)
        return sample->searchField();
    return QVariant();
}


QHash<int, QByteArray> SamplesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[IsMosaic] = "isMosaic";
    roles[Status] = "status";
    roles[Comment] = "comment";
    roles[Source] = "source";
    roles[Reference] = "reference";
    roles[UpdateDate] = "updateDate";
    roles[SearchField] = "searchField";
    return roles;
}


