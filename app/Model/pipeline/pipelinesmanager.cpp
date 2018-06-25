#include "pipelinesmanager.h"
#include "Model/regovar.h"

PipelinesManager::PipelinesManager(QObject *parent) : QObject(parent)
{
    mAvailablePipes = new PipelinesListModel(this);
    mInstalledPipes = new PipelinesListModel(this);
}




void PipelinesManager::loadJson(QJsonArray json)
{
    mInstalledPipes->loadJson(json);
    for (const QJsonValue& pipeJson: json)
    {
        QJsonObject pipeData = pipeJson.toObject();
        Pipeline* pipe = regovar->pipelinesManager()->getOrCreatePipe(pipeData["id"].toInt());
        pipe->loadJson(pipeData);
        mAvailablePipes->add(pipe);
        if (pipe->status() == "ready")
        {
            mInstalledPipes->add(pipe);
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



Pipeline* PipelinesManager::install(int fileId)
{
    Request* req = Request::get(QString("/pipeline/install/%1").arg(fileId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            // Last events
            int pid = json["id"].toInt();
            Pipeline* pipe = getOrCreatePipe(pid);
            pipe->loadJson(json);
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}








void PipelinesManager::processPushNotification(QString, QJsonObject)
{
    // TODO
}
