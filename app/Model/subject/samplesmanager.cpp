#include "samplesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/subject/subject.h"

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


void SamplesManager::propagateDataChanged()
{
    // When a sample in the model emit a datachange, the list need to
    // notify its view to refresh too
    Sample* sample = (Sample*) sender();
    if (sample!= nullptr && mSamplesList.contains(sample))
    {
        emit dataChanged(index(mSamplesList.indexOf(sample)), index(mSamplesList.indexOf(sample)));
    }
}


Sample* SamplesManager::getOrCreateSample(int sampleId, bool internalRefresh)
{

    if (mSamples.contains(sampleId))
    {
        return mSamples[sampleId];
    }
    // else
    if (!internalRefresh) beginInsertRows(QModelIndex(), rowCount(), rowCount());
    Sample* newSample = new Sample(sampleId, this);
    mSamples.insert(sampleId, newSample);
    if (!mSamplesList.contains(newSample))
    {
        mSamplesList.append(newSample);
        connect(newSample, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
    }
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

    Request* req = Request::get(QString("/samples/ref/%1").arg(refId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            loadJson(json["data"].toArray());
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}
bool SamplesManager::loadJson(const QJsonArray& json)
{
    beginResetModel();
    for (Sample* s: mSamplesList)
        disconnect(s, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
    mSamplesList.clear();
    for (const QJsonValue& sampleJson: json)
    {
        QJsonObject sampleData = sampleJson.toObject();
        Sample* sample = getOrCreateSample(sampleData["id"].toInt(), true);
        sample->loadJson(sampleData);
        if (!mSamplesList.contains(sample))
        {
            mSamplesList.append(sample);
            connect(sample, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
        }
    }
    endResetModel();
    emit referencialIdChanged();
    emit countChanged();
    return true;
}


void SamplesManager::importFromFile(int fileId, int refId, FilteringAnalysis* analysis, Subject* subject)
{
    Request* req = Request::get(QString("/sample/import/%1/%2").arg(QString::number(fileId), QString::number(refId)));
    connect(req, &Request::responseReceived, [this, req, fileId, analysis, subject](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QList<QObject*> samples;
            QList<int> samplesIds;
            for (const QJsonValue& sampleValue: json["data"].toArray())
            {
                QJsonObject sampleData = sampleValue.toObject();
                Sample* sample = getOrCreateSample(sampleData["id"].toInt());
                if (sample->loadJson(sampleData))
                {
                    samples.append(sample);
                    samplesIds.append(sample->id());

                    // Add samples to the subject if needed
                    if (subject != nullptr)
                    {
                        subject->addSample(sample);
                    }
                }
            }
            // Add samples to the analysis if needed
            if (analysis != nullptr)
            {
                analysis->addSamples(samples);
            }

            emit sampleImportStart(fileId, samplesIds);
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
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

        Sample* sample = getOrCreateSample(sid);
        sample->setStatus(status);
        sample->setLoadingProgress(progressValue);
        sample->refreshUIAttributes();
        emit sample->dataChanged();
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
    else if (role == Subj && sample->subject() != nullptr)
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
    roles[Subj] = "subject";
    roles[Reference] = "reference";
    roles[SearchField] = "searchField";
    return roles;
}

