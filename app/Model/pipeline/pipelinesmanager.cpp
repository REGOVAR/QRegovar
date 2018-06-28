#include "pipelinesmanager.h"
#include "Model/regovar.h"

PipelinesManager::PipelinesManager(QObject *parent) : QObject(parent)
{
    mAllPipes = new PipelinesListModel(this);
    mInstalledPipes = new PipelinesListModel(this);
}




void PipelinesManager::loadJson(const QJsonArray& json)
{
    for (const QJsonValue& pipeJson: json)
    {
        QJsonObject pipeData = pipeJson.toObject();
        Pipeline* pipe = regovar->pipelinesManager()->getOrCreatePipe(pipeData["id"].toInt());
        pipe->loadJson(pipeData);
        mAllPipes->append(pipe);
        if (pipe->status() == "ready")
        {
            mInstalledPipes->append(pipe);
        }
    }
}





Pipeline* PipelinesManager::getOrCreatePipe(int pipeId)
{
    if (mPipelines.contains(pipeId))
    {
        return mPipelines[pipeId];
    }
    // else
    Pipeline* newPipe = new Pipeline(pipeId, this);
    mPipelines.insert(pipeId, newPipe);
    return newPipe;
}



void PipelinesManager::install(int fileId)
{
    Request* req = Request::get(QString("/pipeline/install/%1").arg(fileId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            // Append new pipeline
            int pid = json["id"].toInt();
            Pipeline* pipe = getOrCreatePipe(pid);
            pipe->loadJson(json["data"].toObject());
            mAllPipes->append(pipe);
            if (pipe->status() == "ready")
                mInstalledPipes->append(pipe);
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}


void PipelinesManager::uninstall(Pipeline* pipeline)
{
    if (pipeline != nullptr && mPipelines.contains(pipeline->id()))
    {
        Request* req = Request::del(QString("/pipeline/%1").arg(pipeline->id()));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                // Remove pipeline
                QJsonObject data = json["data"].toObject();
                Pipeline* pipe = getOrCreatePipe(data["id"].toInt());
                mAllPipes->remove(pipe);
                mInstalledPipes->remove(pipe);
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}






void PipelinesManager::processPushNotification(QString, QJsonObject)
{
    // TODO
}

