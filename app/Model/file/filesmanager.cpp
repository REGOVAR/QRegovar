
#include "filesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

FilesManager::FilesManager(QObject *parent) : QObject(parent)
{
    mUploader = new TusUploader();
    mUploader->setUploadUrl(regovar->serverUrl().toString() + "/file/upload");
    mUploader->setRootUrl(regovar->serverUrl().toString());
    mUploader->setChunkSize(50 * 1024);
    mUploader->setBandWidthLimit(0);

    connect(mUploader,  SIGNAL(filesEnqueued(QHash<QString,QString>)), this, SLOT(filesEnqueued(QHash<QString,QString>)));
}



File* FilesManager::getOrCreateFile(int id)
{
    if (!mFiles.contains(id))
    {
        // Create new file
        mFiles.insert(id, new File(id));
    }
    return mFiles[id];
}



void FilesManager::loadFilesBrowser()
{
    Request* req = Request::get(QString("/file"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mRemoteFilesList.clear();
            foreach( QJsonValue data, json["data"].toArray())
            {
                QJsonObject fileData = data.toObject();
                File* file = getOrCreateFile(fileData["id"].toInt());
                file->fromJson(fileData);
                mRemoteFilesList.append(file);
            }
            emit remoteListChanged();
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



void FilesManager::enqueueUploadFile(QStringList filesPaths)
{
    mUploader->enqueue(filesPaths);
}



void FilesManager::filesEnqueued(QHash<QString,QString> mapping)
{
    // Occure when tusUploader ends to enqueue all files according to TUS upload protocol.
    // Then, manager have to update uploadFilesList to allow the user to see files upload progress
    qDebug() << "Upload mapping Done !";
    foreach (QString key, mapping.keys())
    {
        // retrieve file id into the mapping url
        QStringList pathSplitted = mapping[key].split("/");
        int id = pathSplitted[pathSplitted.count()-1].toInt();
        File* file = getOrCreateFile(id);
        file->load();
        mUploadsList.append(file);

        qDebug() << key << " => " << mapping[key] << id;
    }
    updateUploadProgress();
}



void FilesManager::cancelUploadFile(QList<int> filesId)
{
    foreach (int id, filesId)
    {
        if (mFiles.contains(id))
        {
            File* file = mFiles[id];
            if (mUploadsList.indexOf(file) != -1)
            {
                mUploader->cancel(QString::number(id));
                mUploadsList.removeAll(file);
            }
        }
    }
    updateUploadProgress();
}


void FilesManager::clearUploadsList()
{
    mUploadsList.clear();
}



void FilesManager::processPushNotification(QString action, QJsonObject json)
{
    if (action == "file_upload")
    {
        // update file informations
        int id = json["id"].toInt();
        File* file = getOrCreateFile(id);
        file->fromJson(json);
        // update global upload progress
        if (mUploadsList.indexOf(file) != -1)
        {
            updateUploadProgress();
        }
    }
}



void FilesManager::updateUploadProgress()
{
    if (mUploadsList.count() > 0)
    {
        int totalProgress = 0;
        foreach (QObject* o, mUploadsList)
        {
            File* f = qobject_cast<File*>(o);
            int progress;
            double s = f->size();
            if (s>0) progress = f->uploadOffset() / s * 100;
            totalProgress += progress;
        }
        mUploadsProgress = totalProgress / mUploadsList.count();
    }
    emit uploadsChanged();
}
