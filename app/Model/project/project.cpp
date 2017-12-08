#include "project.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/analysis/filtering/filteringanalysis.h"






Project::Project(QObject* parent) : QObject(parent)
{
}
Project::Project(QJsonObject json, QObject* parent) : QObject(parent)
{
    fromJson(json);
}
Project::Project(int id, QObject* parent) : QObject(parent)
{
    mId = id;
}




bool Project::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    if(json.keys().contains("fullpath"))
    {
        mFullPath = json["fullpath"].toString();
    }
    mCreationDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    mIsSandbox = json["is_sandbox"].toBool();
    mIsFolder = json["is_folder"].toBool();
    mComment = json["comment"].toString();
    mName = json["name"].toString();

    // Analyses
    // TODO: lazy loading of analyses
    for (const QJsonValue& jsonVal: json["analyses"].toArray())
    {
        FilteringAnalysis* analysis = new FilteringAnalysis();
        analysis->fromJson(jsonVal.toObject(), false);
        mAnalyses.append(analysis);
    }

    emit dataChanged();

    return true;
}

QJsonObject Project::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("comment", mComment);
    result.insert("is_folder", mIsFolder);
    if (mParent != nullptr)
    {
        result.insert("parent_id", mParent->id());
    }
    // Analyses
    if (mAnalyses.count() > 0)
    {
        QJsonArray analyses;
        for (QObject* o: mAnalyses)
        {
            FilteringAnalysis* a = qobject_cast<FilteringAnalysis*>(o);
            analyses.append(a->id());
        }
        result.insert("analyses_ids", analyses);
    }
    // TODO: Jobs
    // TODO: Indicators

    return result;
}





void Project::save()
{
    if (mId == -1) return;
    Request* request = Request::put(QString("/project/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Project saved";
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



void Project::load()
{
    Request* req = Request::get(QString("/project/%1").arg(mId));
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
