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


void PipelinesManager::processPushNotification(QString, QJsonObject)
{
    // TODO
}
