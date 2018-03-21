#include "pipelineanalysis.h"

#include "Model/file/file.h"
#include "Model/regovar.h"

PipelineAnalysis::PipelineAnalysis(QObject* parent) : Analysis(parent)
{
    mInputsFiles = new FilesListModel(this);
    mOutputsFiles = new FilesListModel(this);
    mType = Analysis::PIPELINE;
    mMenuModel->initPipelineAnalysis();
}

PipelineAnalysis::PipelineAnalysis(int id, QObject* parent) : PipelineAnalysis(parent)
{
    mId = id;
}




void PipelineAnalysis::addInputs(QList<QObject*> inputs)
{
    for (QObject* o1: inputs)
    {
        File* file = qobject_cast<File*>(o1);
        mInputsFiles->add(file);
    }
}

void PipelineAnalysis::removeInputs(QList<QObject*> inputs)
{
    for (QObject* o1: inputs)
    {
        File* file = qobject_cast<File*>(o1);
        mInputsFiles->remove(file);
    }
}

void PipelineAnalysis::addInputFromWS(QJsonObject json)
{

    File* file = regovar->filesManager()->getOrCreateFile(json["id"].toInt());
    file->fromJson(json);
    mInputsFiles->add(file);
}


void PipelineAnalysis::setPipeline(Pipeline* pipe)
{
    mPipeline = pipe;
    mPipeline->configForm()->load(mPipeline->form());
    mPipeline->configForm()->reset();
    emit pipelineChanged();
}



bool PipelineAnalysis::fromJson(QJsonObject json, bool full_init)
{
    mId = json["id"].toInt();
    if (json.contains("name")) setName(json["name"].toString());
    if (json.contains("status")) setStatus(json["status"].toString());
    if (json.contains("comment")) setComment(json["comment"].toString());
    if (json.contains("project_id")) setProject(regovar->projectsManager()->getOrCreateProject(json["project_id"].toInt()));
    if (json.contains("update_date")) mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    if (json.contains("create_date")) mCreateDate = QDateTime::fromString(json["create_date"].toString(), Qt::ISODate);
    if (json.contains("config")) mConfig =json["config"].toObject();
    if (json.contains("status")) setStatus(json["status"].toString());
    if (json.contains("pipeline_id")) mPipeline = regovar->pipelinesManager()->getOrCreatePipe(json["pipeline_id"].toInt());

    if (json.contains("progress_label")) mProgressLabel = json["progress_label"].toString();
    if (json.contains("progress_value")) mProgressValue = json["progress_value"].toDouble();

    // Inputs files
    if (json.contains("inputs"))
    {
        mInputsFiles->clear();
        for (const QJsonValue& fileVal: json["inputs"].toArray())
        {
            QJsonObject fileData = fileVal.toObject();
            File* file = regovar->filesManager()->getOrCreateFile(fileData["id"].toInt());
            file->fromJson(fileData);
            mInputsFiles->add(file);
        }
    }
    else if (json.contains("inputs_ids"))
    {
        mInputsFiles->clear();
        for (const QJsonValue& fileId: json["inputs_ids"].toArray())
        {
            File* file = regovar->filesManager()->getOrCreateFile(fileId.toInt());
            if (full_init)
            {
                file->load(true);
            }
            mInputsFiles->add(file);
        }
    }
    // Outputs files
    if (json.contains("outputs"))
    {
        mOutputsFiles->clear();
        for (const QJsonValue& fileVal: json["outputs"].toArray())
        {
            QJsonObject fileData = fileVal.toObject();
            File* file = regovar->filesManager()->getOrCreateFile(fileData["id"].toInt());
            file->fromJson(fileData);
            mOutputsFiles->add(file);
        }
    }
    else if (json.contains("outputs_ids"))
    {
        mOutputsFiles->clear();
        for (const QJsonValue& fileId: json["outputs_ids"].toArray())
        {
            File* file = regovar->filesManager()->getOrCreateFile(fileId.toInt());
            if (full_init)
            {
                file->load(true);
            }
            mOutputsFiles->add(file);
        }
    }

    if (!mLoaded && full_init)
    {
        if (json.contains("pipeline"))
        {
            mPipeline->fromJson(json["pipeline"].toObject());
        }
        else
        {
            mPipeline->load(true);
        }
        mLoaded = true;
    }

    emit dataChanged();
    return true;
}


QJsonObject PipelineAnalysis::toJson()
{
    QJsonObject result;
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("comment", mComment);
    result.insert("config", mConfig);
    if (mPipeline != nullptr)
    {
        result.insert("pipeline_id", mPipeline->id());
    }

    QJsonArray inputs;
    for(int idx=0; idx<mInputsFiles->rowCount(); idx++)
    {
        File* file = mInputsFiles->getAt(idx);
        inputs.append(file->id());
    }
    result.insert("inputs_ids", inputs);

    QJsonArray outputs;
    for(int idx=0; idx<mOutputsFiles->rowCount(); idx++)
    {
        File* file = mOutputsFiles->getAt(idx);
        outputs.append(file->id());
    }
    result.insert("outputs_ids", outputs);

    return result;
}


void PipelineAnalysis::save()
{
    if (mId == -1) return;
    Request* request = Request::put(QString("/job/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Pipeline analysis saved";
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        request->deleteLater();
    });
}


void PipelineAnalysis::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/job/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                fromJson(json["data"].toObject(), true);
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
}




void PipelineAnalysis::pause()
{
    if (mStatus == "running")
    {
        Request* req = Request::get(QString("/job/%1/pause").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                fromJson(json["data"].toObject());
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
}


void PipelineAnalysis::start()
{
    if (mStatus == "pause")
    {
        Request* req = Request::get(QString("/job/%1/start").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                fromJson(json["data"].toObject());
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
}


void PipelineAnalysis::cancel()
{
    Request* req = Request::get(QString("/job/%1/cancel").arg(mId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            fromJson(json["data"].toObject());
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


void PipelineAnalysis::finalyze()
{
    if (mStatus == "running")
    {
        Request* req = Request::get(QString("/job/%1/finalyze").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                fromJson(json["data"].toObject());
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
}


void PipelineAnalysis::refreshMonitoring()
{
    Request* req = Request::get(QString("/job/%1/monitoring").arg(mId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            // TODO: parsing monitoring informations
            //fromJson(json["data"].toObject());
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



void PipelineAnalysis::processPushNotification(QString action, QJsonObject data)
{
    if (action == "job_updated")
    {
        fromJson(data, true);
    }
}
