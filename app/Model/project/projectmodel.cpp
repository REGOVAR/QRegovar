#include "projectmodel.h"

ProjectModel::ProjectModel(QObject* parent) : QObject(parent), mIsFolder(false), mIsSandbox(false)
{
}

ProjectModel::ProjectModel(bool isFolder, bool isSandbox, QObject* parent) : QObject(parent)
{
    mIsFolder = isFolder;
    mIsSandbox = isSandbox;
}



bool ProjectModel::fromJson(QJsonDocument json)
{
    QJsonObject data = json.object();
    return fromJson(data);
}


bool ProjectModel::fromJson(QJsonObject json)
{
    // TODO set current user with json data
    // QString st(json.toJson(QJsonDocument::Compact));
    mId = json["id"].toInt();
    mFullPath = "";
    mParent = nullptr;
    mCreationDate = QDateTime::fromString(json["creation_date"].toString());
    mUpdateDate = QDateTime::fromString(json["update_date"].toString());
    mIsSandbox = json["is_sandbox"].toBool();
    mIsFolder = json["is_folder"].toBool();
    mComment = json["comment"].toString();
    mName = json["name"].toString();
    return true;
}




void ProjectModel::setParent(ProjectModel* parent)
{
    if (mParent != nullptr)
    {
        mParent->deleteLater();
    }
    mParent = parent;
    emit parentUpdated();
}
