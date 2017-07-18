#include "projectmodel.h"

ProjectModel::ProjectModel(QObject* parent) : QObject(parent), mIsFolder(false), mIsSandbox(false)
{
    mFiles = new FilesTreeViewModel();
}

ProjectModel::ProjectModel(bool isFolder, bool isSandbox, QObject* parent) : QObject(parent)
{
    mIsFolder = isFolder;
    mIsSandbox = isSandbox;
    mFiles = new FilesTreeViewModel();
}



bool ProjectModel::fromJson(QJsonDocument json)
{
    QJsonObject data = json.object();
    return fromJson(data);
}


bool ProjectModel::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mFullPath = "";
    //mParent->fromJson(json["parent"].toObject());
    mCreationDate = QDateTime::fromString(json["creation_date"].toString());
    mUpdateDate = QDateTime::fromString(json["update_date"].toString());
    mIsSandbox = json["is_sandbox"].toBool();
    mIsFolder = json["is_folder"].toBool();
    mComment = json["comment"].toString();
    mName = json["name"].toString();

    mFiles->fromJson(json["files"].toArray());


    emit parentUpdated();
    emit updateDateUpdated();
    emit commentUpdated();
    emit nameUpdated();
    emit filesUpdated();

    return true;
}




void ProjectModel::setParent(ProjectModel* parent)
{
    // TODO : to be complient with QML binding : need to copy parent into mParent instead of erasing mParent
    mParent = parent;
    emit parentUpdated();
}
