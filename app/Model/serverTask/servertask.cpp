#include "servertask.h"
#include "Model/regovar.h"

ServerTask::ServerTask(QObject* parent): RegovarResource(parent)
{
    connect(this, &ServerTask::dataChanged, this, &ServerTask::updateSearchField);
}




bool ServerTask::loadJson(QJsonObject json, bool)
{
    mId = json["task_action"].toString();
    if (mId == "file_upload")
    {
        mId += "_" + json["id"].toString();
        mStatus = json["status"].toString();
        mProgress = json["upload_offset"].toDouble() / json["size"].toDouble();
        mLabel = tr("Uploading") + ": " + json["name"].toString();
    }
    emit dataChanged();
}




void ServerTask::updateSearchField()
{
    mSearchField = mStatus + " " + mLabel;
}
