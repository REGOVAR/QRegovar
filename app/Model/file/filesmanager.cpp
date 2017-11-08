
#include "filesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"
#include "Model/file/file.h"

FilesManager::FilesManager(QObject *parent) : QObject(parent)
{
    mUploader = new TusUploader();
    mUploader->setUploadUrl(regovar->serverUrl().toString() + "/file/upload");
    mUploader->setRootUrl(regovar->serverUrl().toString());
    mUploader->setChunkSize(50 * 1024);
    mUploader->setBandWidthLimit(0);

    connect(mUploader,  SIGNAL(filesEnqueued(QHash<QString,QString>)), this, SLOT(filesEnqueued(QHash<QString,QString>)));
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
                File* file = new File();
                file->fromJson(data.toObject());
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
    qDebug() << "Upload mapping Done !";
    foreach (QString key, mapping.keys())
    {
        qDebug() << key << " => " << mapping[key];
    }
}

void FilesManager::cancelUploadFile(QStringList)
{
    qDebug() << "TODO: cancelUploadFile";
}
