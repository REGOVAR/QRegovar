#include "project.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/analysis/pipeline/pipelineanalysis.h"






Project::Project(QObject* parent) : QObject(parent)
{
    mAnalyses = new AnalysesListModel(this);
}
Project::Project(QJsonObject json, QObject* parent) : Project(parent)
{
    loadJson(json);
}
Project::Project(int id, QObject* parent) : Project(parent)
{
    mId = id;
}





bool Project::loadJson(QJsonObject json)
{
    mId = json["id"].toInt();
    if(json.keys().contains("fullpath"))
    {
        mFullPath = json["fullpath"].toString();
    }
    mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    mIsSandbox = json["is_sandbox"].toBool();
    mIsFolder = json["is_folder"].toBool();
    mComment = json["comment"].toString();
    mName = json["name"].toString();

    // Analyses
    mAnalyses->clear();
    for (const QJsonValue& jsonVal: json["analyses"].toArray())
    {
        QJsonObject aJson = jsonVal.toObject();
        FilteringAnalysis* analysis =  regovar->analysesManager()->getOrCreateFilteringAnalysis(aJson["id"].toInt());
        analysis->loadJson(aJson, false);
        mAnalyses->append(analysis);
    }
    for (const QJsonValue& jsonVal: json["jobs"].toArray())
    {
        QJsonObject jJson = jsonVal.toObject();
        PipelineAnalysis* analysis =  regovar->analysesManager()->getOrCreatePipelineAnalysis(jJson["id"].toInt());
        analysis->loadJson(jJson, false);
        mAnalyses->append(analysis);
    }

    // Subjects
    mSubjects.clear();
    for (const QJsonValue& jsonVal: json["subjects"].toArray())
    {
        QJsonObject aJson = jsonVal.toObject();
        int id = aJson["id"].toInt();
        Subject* subject =  regovar->subjectsManager()->getOrCreateSubject(id);
        subject->loadJson(jsonVal.toObject());
        mSubjects.append(subject);
    }

    mLoaded = true;
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
    if (mAnalyses->rowCount() > 0)
    {
        QJsonArray analyses;
        for (int idx=0; idx < mAnalyses->rowCount(); idx++)
        {
            Analysis* a = mAnalyses->getAt(idx);
            analyses.append(a->id());
        }
        result.insert("analyses_ids", analyses);
    }
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
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}


void Project::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/project/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                loadJson(json["data"].toObject());
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}
