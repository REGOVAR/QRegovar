#include "project.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/analysis/pipeline/pipelineanalysis.h"






Project::Project(QObject* parent) : RegovarResource(parent)
{
    mAnalyses = new AnalysesListModel(this);
    mSubjects = new SubjectsListModel(this);

    connect(mAnalyses, SIGNAL(dataChanged(QModelIndex,QModelIndex,QVector<int>)), this, SLOT(propagateDataChanged()));
    connect(mSubjects, SIGNAL(dataChanged(QModelIndex,QModelIndex,QVector<int>)), this, SLOT(propagateDataChanged()));
}
Project::Project(QJsonObject json, QObject* parent) : Project(parent)
{
    loadJson(json);
}
Project::Project(int id, QObject* parent) : Project(parent)
{
    mId = id;
}





void Project::propagateDataChanged()
{
    // When an analysis in the model emit a datachange, the project need to
    // notify its view to refresh too
    emit dataChanged();
}




bool Project::loadJson(const QJsonObject& json, bool)
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
    if (json.contains("analyses"))
    {
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
    }
    else if (json.contains("analyses_ids"))
    {
        mAnalyses->clear();
        for (const QJsonValue& aId: json["analyses_ids"].toArray())
        {
            FilteringAnalysis* analysis =  regovar->analysesManager()->getOrCreateFilteringAnalysis(aId.toInt());
            mAnalyses->append(analysis);
        }
        for (const QJsonValue& aId: json["jobs_ids"].toArray())
        {
            PipelineAnalysis* analysis =  regovar->analysesManager()->getOrCreatePipelineAnalysis(aId.toInt());
            mAnalyses->append(analysis);
        }
    }


    // Subjects
    if (json.contains("subjects"))
    {
        mSubjects->clear();
        for (const QJsonValue& jsonVal: json["subjects"].toArray())
        {
            QJsonObject sJson = jsonVal.toObject();
            Subject* subject =  regovar->subjectsManager()->getOrCreateSubject(sJson["id"].toInt());
            subject->loadJson(sJson);
            mSubjects->append(subject);
        }
    }
    else if (json.contains("subjects_ids"))
    {
        mAnalyses->clear();
        for (const QJsonValue& sId: json["subjects_ids"].toArray())
        {
            Subject* subject =  regovar->subjectsManager()->getOrCreateSubject(sId.toInt());
            mSubjects->append(subject);
        }
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

    // TODO: Indicators

    // No need to serialize analyses_ids and jobs_ids.
    // To update this information you have to update concerned analyses and jobs

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
