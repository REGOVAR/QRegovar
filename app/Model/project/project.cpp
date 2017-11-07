#include "project.h"

#include "Model/analysis/filtering/filteringanalysis.h"

Project::Project(QObject* parent) : QObject(parent), mIsFolder(false), mIsSandbox(false)
{
    mFiles = new FilesTreeModel();
}

Project::Project(bool isFolder, bool isSandbox, QObject* parent) : QObject(parent)
{
    mIsFolder = isFolder;
    mIsSandbox = isSandbox;
    mFiles = new FilesTreeModel();
}



bool Project::fromJson(QJsonDocument json)
{
    QJsonObject data = json.object();
    return fromJson(data);
}


bool Project::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    if(json.keys().contains("fullpath"))
    {
        mFullPath = json["fullpath"].toString();
    }
    mCreationDate = QDateTime::fromString(json["creation_date"].toString());
    mUpdateDate = QDateTime::fromString(json["update_date"].toString());
    mIsSandbox = json["is_sandbox"].toBool();
    mIsFolder = json["is_folder"].toBool();
    mComment = json["comment"].toString();
    mName = json["name"].toString();
    mFiles->fromJson(json["files"].toArray());

    // Analyses
    foreach (QJsonValue jsonVal, json["analyses"].toArray())
    {
        FilteringAnalysis* analysis = new FilteringAnalysis();
        analysis->fromJson(jsonVal.toObject());
        mAnalyses.append(analysis);
    }

    // Events
//    foreach (QJsonValue jsonVal, json["events"].toArray())
//    {
//        mEvents.append("Salut");
//    }




    emit dataChanged();

    return true;
}






void Project::setParent(Project* parent)
{
    // TODO : to be complient with QML binding : need to copy parent into mParent instead of erasing mParent
    mParent = parent;
    emit dataChanged();
}
