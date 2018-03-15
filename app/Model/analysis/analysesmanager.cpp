#include "analysesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "filtering/filteringanalysis.h"
#include "pipeline/pipelineanalysis.h"


QString AnalysesManager::FILTERING = QString("analysis");
QString AnalysesManager::PIPELINE = QString("pipeline");



AnalysesManager::AnalysesManager(QObject *parent) : QObject(parent)
{
    // Force the manager as Parent of these analysis to avoid garbage collector to destroy them unexpectedly
    // We force 0 as id. -1 is for unvalid analysis, >0 is for existing analyses in Regovar srver DB, 0 is for new wizard models
    mNewPipeline = new PipelineAnalysis(0, this);
    mNewFiltering = new FilteringAnalysis(0, this);
}




void AnalysesManager::resetNewFiltering(int refId)
{
    if (refId == mNewFiltering->refId()) return;

    // clear data in newAnalyses wrappers
    mNewFiltering->removeSamples(mNewFiltering->samples4qml());
    mNewFiltering->samples().clear();
    mNewFiltering->setComment("");
    mNewFiltering->setName("");
    mNewFiltering->setIsTrio(false);

    // reset references
    int idx = 0;
    for (QObject* o: regovar->references())
    {
        Reference* ref = qobject_cast<Reference*>(o);
        if (ref->id() == refId)
        {
            mNewFiltering->setReference(ref, true);
            break;
        }
        ++idx;
    }
    regovar->samplesManager()->setReferenceId(refId);
    emit newFilteringChanged();
}


void AnalysesManager::resetNewPipeline()
{
    // TODO
    emit newPipelineChanged();
}




bool AnalysesManager::newAnalysis(QString type)
{
    if (type == FILTERING)
    {
        // Samples
        QJsonArray ids;
        for (Sample* s: mNewFiltering->samples())
        {
            ids.append(QJsonValue(s->id()));
        }

        // Settings
        QJsonObject settings;
        QJsonArray dbs;
        settings.insert("annotations_db", dbs);
        if (mNewFiltering->isTrio())
        {
            QJsonObject trioSettings;
            trioSettings.insert("child_id", mNewFiltering->trioChild()->id());
            trioSettings.insert("child_index", mNewFiltering->trioChild()->isIndex());
            trioSettings.insert("child_sex", mNewFiltering->trioChild()->sex());
            trioSettings.insert("mother_id", mNewFiltering->trioMother()->id());
            trioSettings.insert("mother_index", mNewFiltering->trioMother()->isIndex());
            trioSettings.insert("father_id", mNewFiltering->trioFather()->id());
            trioSettings.insert("father_index", mNewFiltering->trioFather()->isIndex());
            settings.insert("trio", trioSettings);
        }
        else
        {
            settings.insert("trio", false);
        }

        // Attributes
        QJsonArray attributes;
        if (mNewFiltering->attributes().count() > 0)
        {
            for (QObject* o: mNewFiltering->attributes())
            {
                Attribute* attr = qobject_cast<Attribute*>(o);
                attributes.append(attr->toJson());
            }
        }

        // Save Subjects-samples associations
        for (QObject* o: mNewFiltering->samples())
        {
            Sample* sample = qobject_cast<Sample*>(o);
            sample->save();
            if (sample->subject() != nullptr)
            {
                sample->subject()->save();
            }
        }

        // Send request to server
        QJsonObject body;
        Project* proj = mNewFiltering->project();
        body.insert("project_id", proj->id());
        body.insert("reference_id", mNewFiltering->refId());
        body.insert("name", mNewFiltering->name());
        body.insert("samples_ids", ids);
        body.insert("settings", settings);
        body.insert("attributes", attributes);

        Request* req = Request::post(QString("/analysis"), QJsonDocument(body).toJson());
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                QJsonObject data = json["data"].toObject();
                int id = data["id"].toInt();
                // Open new analysis
                bool result = openAnalysis(FILTERING, id, false);

                if (result)
                {
                    // Start creation of the working table by sending the first "filtering" query
                    QJsonObject body;
                    body.insert("filter", data["filter"].toArray());
                    body.insert("fields", data["fields"].toArray());
                    Request* req2 = Request::post(QString("/analysis/%1/filtering").arg(id), QJsonDocument(body).toJson());
                    req2->deleteLater();
                }

                // notify HMI that analysis is created (=> close newAnalizeWizard dialog)
                emit analysisCreationDone(false, result ? id :-1);
            }
            else
            {
                QJsonObject jsonError = json;
                jsonError.insert("method", Q_FUNC_INFO);
                regovar->raiseError(jsonError);
                emit analysisCreationDone(false, -1);
            }
            req->deleteLater();
        });
    }
    else if (type == PIPELINE)
    {

        Request* req = Request::post(QString("/job"), QJsonDocument(mNewPipeline->toJson()).toJson());
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                QJsonObject data = json["data"].toObject();
                int id = data["id"].toInt();
                // Open new analysis
                bool result = openAnalysis(PIPELINE, id, false);

                // notify HMI that analysis is created (=> close newAnalizeWizard dialog)
                emit analysisCreationDone(false, result ? id :-1);
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
    return true;
}






bool AnalysesManager::openAnalysis(QString type, int id, bool reload_from_server)
{
    // Get analysis
    Analysis* analysis = nullptr;
    QUrl url;
    if (type == FILTERING)
    {
        analysis = getOrCreateFilteringAnalysis(id);
        url = QUrl("qrc:/qml/AnalysisWindow.qml");
    }
    if (type == PIPELINE)
    {
        analysis = getOrCreatePipelineAnalysis(id);
        url = QUrl("qrc:/qml/JobWindow.qml");
    }

    if (analysis == nullptr)
        return false;

    // Refresh / get all information of the analysis
    if (reload_from_server)
    {
        analysis->load();
    }

    // open it in a new windows
    return regovar->openNewWindow(url, analysis);
}


bool AnalysesManager::loadJson(QJsonArray json)
{
    for (const QJsonValue& data: json)
    {
        QJsonObject item = data.toObject();
        if (item.contains("pipeline_id"))
        {
            // Load job analysis
            // TODO
        }
        else
        {
            // Load filtering analysis
            FilteringAnalysis* fa = getOrCreateFilteringAnalysis(item["id"].toInt());
            fa->fromJson(item, false);
        }
    }
}



FilteringAnalysis* AnalysesManager::getOrCreateFilteringAnalysis(int id)
{
    if (mFilteringAnalyses.contains(id))
    {
        return mFilteringAnalyses[id];
    }
    // else
    FilteringAnalysis* newAnalysis = new FilteringAnalysis(id);
    mFilteringAnalyses.insert(id, newAnalysis);
    return newAnalysis;
}

PipelineAnalysis* AnalysesManager::getOrCreatePipelineAnalysis(int id)
{
    if (mPipelineAnalyses.contains(id))
    {
        return mPipelineAnalyses[id];
    }
    // else
    PipelineAnalysis* newAnalysis = new PipelineAnalysis(id);
    mPipelineAnalyses.insert(id, newAnalysis);
    return newAnalysis;
}
FilteringAnalysis* AnalysesManager::getFilteringAnalysis(int id)
{
    if (mFilteringAnalyses.contains(id))
    {
        return mFilteringAnalyses[id];
    }
    return nullptr;
}
PipelineAnalysis* AnalysesManager::getPipelineAnalysis(int id)
{
    if (mPipelineAnalyses.contains(id))
    {
        return mPipelineAnalyses[id];
    }
    return nullptr;
}


void AnalysesManager::deleteFilteringAnalysis(int id)
{
    Request* req = Request::del(QString("/analysis/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            regovar->projectsManager()->refresh();
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

void AnalysesManager::deletePipelineAnalysis(int id)
{
    Request* req = Request::del(QString("/job/%1").arg(id));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            regovar->projectsManager()->refresh();
            regovar->loadWelcomData();
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
