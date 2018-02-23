#include "samplesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

SamplesManager::SamplesManager(QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}
SamplesManager::SamplesManager(int refId, QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
    if (refId > 0)
    {
        setReferenceId(refId);
    }
}


Sample* SamplesManager::getOrCreate(int sampleId, bool internalRefresh)
{

    if (mSamples.contains(sampleId))
    {
        return mSamples[sampleId];
    }
    // else
    if (!internalRefresh) beginInsertRows(QModelIndex(), rowCount(), rowCount());
    Sample* newSample = new Sample(sampleId, this);
    mSamples.insert(sampleId, newSample);
    if (!mSamplesList.contains(newSample)) mSamplesList.append(newSample);
    if (!internalRefresh)
    {
        endInsertRows();
        emit countChanged();
    }
    return newSample;
}






void SamplesManager::setReferenceId(int refId)
{
    if (refId == mRefId) return;
    mRefId = refId;

    Request* req = Request::get(QString("/sample/ref/%1").arg(refId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadJson(json["data"].toArray());
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}
bool SamplesManager::loadJson(QJsonArray json)
{
    beginResetModel();
    mSamplesList.clear();
    for (const QJsonValue& sampleJson: json)
    {
        QJsonObject sampleData = sampleJson.toObject();
        Sample* sample = getOrCreate(sampleData["id"].toInt(), true);
        sample->fromJson(sampleData);
        if (!mSamplesList.contains(sample)) mSamplesList.append(sample);
    }
    endResetModel();
    emit referencialIdChanged();
    emit countChanged();
    return true;
}



void SamplesManager::processPushNotification(QString action, QJsonObject data)
{
    // Retrieve realtime progress data
    QString status = data["status"].toString();
    double progressValue = 0.0;
    if (action == "import_vcf_processing" || action == "import_vcf_start")
    {
        progressValue = data["progress"].toDouble();
    }
    else if (action == "import_vcf_end")
    {
        progressValue = 1.0;
        status = "ready";
    }

    // Update sample status
    for (const QJsonValue& json: data["samples"].toArray())
    {
        QJsonObject obj = json.toObject();
        int sid = obj["id"].toInt();

        Sample* sample = getOrCreate(sid);
        sample->setStatus(status);
        sample->setLoadingProgress(progressValue);
        sample->refreshUIAttributes();
    }

    // Notify view when new sample import start (import wizard)
    if (action == "import_vcf_start")
    {
        QList<int> ids;
        for (QJsonValue sample: data["samples"].toArray())
        {
            QJsonObject sampleData = sample.toObject();
            ids << sampleData["id"].toInt();
        }
        emit sampleImportStart(data["file_id"].toString().toInt(), ids);
    }
}




int SamplesManager::rowCount(const QModelIndex&) const
{
    return mSamplesList.count();
}

QVariant SamplesManager::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mSamplesList.count())
        return QVariant();

    const Sample* sample = mSamplesList[index.row()];
    if (role == Name || role == Qt::DisplayRole)
        return sample->name();
    else if (role == Id)
        return sample->id();
    else if (role == Nickname)
        return sample->nickname();
    else if (role == IsMosaic)
        return sample->isMosaic();
    else if (role == Comment)
        return sample->comment();
    else if (role == Status)
        return sample->statusUI();
    else if (role == Source)
        return sample->sourceUI();
    else if (role == Subject && sample->subject() != nullptr)
        return sample->subject()->subjectUI();
    else if (role == Reference && sample->reference() != nullptr)
        return sample->reference()->name();
    else if (role == SearchField)
        return sample->searchField();
    return QVariant();
}

QHash<int, QByteArray> SamplesManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[Nickname] = "nickname";
    roles[IsMosaic] = "isMosaic";
    roles[Comment] = "comment";
    roles[Status] = "status";
    roles[Source] = "source";
    roles[Subject] = "subject";
    roles[Reference] = "reference";
    roles[SearchField] = "searchField";
    return roles;
}

