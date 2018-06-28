#include "servertask.h"
#include "Model/regovar.h"
#include "Model/analysis/filtering/filteringanalysis.h"

ServerTask::ServerTask(QObject* parent): RegovarResource(parent)
{
    connect(this, &ServerTask::dataChanged, this, &ServerTask::updateSearchField);
}




bool ServerTask::loadJson(const QJsonObject& json, bool)
{
    mId = json["task_action"].toString();
    // File
    if (mId == "file_upload")
    {
        mId += "_" + json["id"].toString();
        mInternalId = json["id"].toString().toInt();
        mStatus = json["status"].toString();
        mType = "file";
        mProgress = json["upload_offset"].toDouble() / json["size"].toDouble();
        mLabel = tr("Uploading") + ": " + json["name"].toString();
        mEnableControls = regovar->filesManager()->uploadsList()->contains(regovar->filesManager()->getOrCreateFile(json["id"].toString().toInt()));
    }

    // "pipeline_install", "pipeline_uninstall"
    // "job_updated"
    // Job
    else if (mId == "import_vcf_start" || mId == "import_vcf_processing" || mId == "import_vcf_end")
    {
        mId = "import_vcf_" + json["file_id"].toString();
        mStatus = json["status"].toString();
        mType = "pipeline";
        mProgress = json["progress"].toDouble();
        mLabel = tr("Importing data") + ": " + json["name"].toString();
        mEnableControls = true;
    }

    // Filtering analysis
    else if (mId == "analysis_computing" || mId == "wt_update" || mId == "wt_creation" || mId == "filter_update")
    {
        if (mId == "wt_creation")
        {
            int step = 0;
            double total = 0;
            for(QJsonValue val: json["log"].toArray())
            {
                step ++;
                total += val.toObject()["progress"].toDouble();
            }
            mProgress = total / step;
        }
        else
        {
            mProgress = json["progress"].toDouble();
        }


        mId = "analysis_" + json["id"].toString();
        mStatus = json["status"].toString();
        mType = "filtering";
        mLabel = tr("Computing analysis") + ": " + regovar->analysesManager()->getOrCreateFilteringAnalysis(json["id"].toInt())->name();
        mEnableControls = true;
    }
    else if (mId == "filter_update")
    {
        mId = "filter_" + json["id"].toString();
        mStatus = json["status"].toString();
        mType = "filtering";
        mProgress = json["progress"].toDouble();
        mLabel = tr("Computing analysis") + ": " + json["name"].toString();
        mEnableControls = false;
    }


    regovar->serverTasks()->updateProgress();
    emit dataChanged();
    return true;
}


void ServerTask::pause()
{
    if (mStatus == "pause")
    {
        if (mType == "file")
            regovar->filesManager()->startUpload(mInternalId);
        mStatus = "running";
    }
    else
    {
        if (mType == "file")
            regovar->filesManager()->pauseUpload(mInternalId);
        mStatus = "pause";
    }

}
void ServerTask::cancel()
{
    if (mType == "file")
        regovar->filesManager()->cancelUpload(mInternalId);
    mStatus = "done";
}
void ServerTask::open()
{
    if (mType == "file")
        regovar->getFileInfo(mInternalId);
}



void ServerTask::updateSearchField()
{
    mSearchField = mStatus + " " + mLabel;
}
