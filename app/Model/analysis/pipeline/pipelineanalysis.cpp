#include "pipelineanalysis.h"

#include "Model/file/file.h"
#include "Model/regovar.h"

PipelineAnalysis::PipelineAnalysis(QObject* parent) : Analysis(parent)
{
    mType = "Pipeline";
}

PipelineAnalysis::PipelineAnalysis(int id, QObject* parent) : PipelineAnalysis(parent)
{
    mId = id;
}


void PipelineAnalysis::addInputs(QList<QObject*> inputs)
{
    for (QObject* o1: inputs)
    {
        File* file = qobject_cast<File*>(o1);
        if (!mInputsFilesIds.contains(file->id()))
        {
            mInputsFilesIds.append(file->id());
            mInputsFilesList.append(file);
        }
    }
    emit inputsFilesListChanged();

}

void PipelineAnalysis::removeInputs(QList<QObject*> inputs)
{
    for (QObject* o1: inputs)
    {
        File* file = qobject_cast<File*>(o1);
        if (mInputsFilesIds.contains(file->id()))
        {
            mInputsFilesIds.removeAll(file->id());
            mInputsFilesList.removeAll(file);
        }
    }
    emit inputsFilesListChanged();
}

void PipelineAnalysis::addInputFromWS(QJsonObject json)
{
    if (!mInputsFilesIds.contains(json["id"].toInt()))
    {
        File* file = new File();
        file->fromJson(json);
        mInputsFilesIds.append(file->id());
        mInputsFilesList.append(file);
        emit inputsFilesListChanged();
    }
}


void PipelineAnalysis::processPushNotification(QString, QJsonObject)
{
    // TODO
//    if (action == "file_upload")
//    {
//        int id = data["id"].toInt();
//        for (QObject* o: mInputsFilesList)
//        {
//            File* file = qobject_cast<File*>(o);
//            if (file->id() != id) continue;

//            // Update file model
//            file->fromJson(data);

//            break;
//        }
//    }
}
