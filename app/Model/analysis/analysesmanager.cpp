#include "analysesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "filtering/filteringanalysis.h"
#include "pipeline/pipelineanalysis.h"

AnalysesManager::AnalysesManager(QObject *parent) : QObject(parent)
{
    // Force the manager as Parent of these analysis to avoid garbage collector to destroy them unexpectedly
    mNewPipeline = new PipelineAnalysis(this);
    mNewFiltering = new FilteringAnalysis(this);
}




void AnalysesManager::resetNewFiltering(int refId)
{
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
    if (type == "filtering")
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
                bool result = openAnalysis("Filtering", id, false);

                if (result)
                {
                    // Start creation of the working table by sending the first "filtering" query
                    QJsonObject body;
                    body.insert("filter", data["filter"].toArray());
                    body.insert("fields", data["fields"].toArray());
                    Request* req2 = Request::post(QString("/analysis/%1/filtering").arg(id), QJsonDocument(body).toJson());
                    req2->deleteLater();

                    // notify HMI that analysis is created
                    emit analysisCreationDone(true, id);
                }
                else
                {
                    emit analysisCreationDone(false, -1);
                }
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
    else if (type == "pipeline")
    {

    }
    return true;
}






bool AnalysesManager::openAnalysis(QString type, int id, bool reload_from_server)
{
    // Get analysis
    Analysis* analysis = nullptr;
    if (type == "Filtering")
    {
        analysis = getOrCreateFilteringAnalysis(id);
    }
    if (type == "Pipeline")
    {
        analysis = getOrCreatePipelineAnalysis(id);
    }
    // Refresh / get all information of the analysis
    if (reload_from_server)
    {
        analysis->load();
    }

    // open it in a new windows
    return regovar->openNewWindow(QUrl("qrc:/qml/AnalysisWindow.qml"), analysis);
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
