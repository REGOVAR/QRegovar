
#include "filesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

FilesManager::FilesManager(QObject *parent) : QObject(parent)
{
    mUploadsList = new FilesListModel(this);
    mRemoteFilesList = new FilesListModel(this);
    mUploader = new TusUploader();
    mUploader->setUploadUrl(regovar->networkManager()->serverUrl().toString() + "/file/upload");
    mUploader->setRootUrl(regovar->networkManager()->serverUrl().toString());
    mUploader->setChunkSize(50 * 1024);
    mUploader->setBandWidthLimit(0);

    connect(mUploader,  SIGNAL(filesEnqueued(QHash<QString,QString>)), this, SLOT(filesEnqueued(QHash<QString,QString>)));

    // Continue uploading files
    QJsonObject data = regovar->settings()->uploadingFiles();
    mUploader->resume(data);
}



void FilesManager::setCacheDir(QString path)
{
    mCacheDir = path;
    if (mCacheDir.isEmpty())
    {
        mCacheDir = QStandardPaths::standardLocations(QStandardPaths::CacheLocation)[0];
    }
    regovar->settings()->setLocalCacheDir(mCacheDir);
    regovar->settings()->save();
    refreshCacheStats();
    emit cacheDirChanged();
}



void FilesManager::setCacheMaxSize(int size)
{
    mCacheMaxSize = qMin(qMax(1,size), 1000);
    regovar->settings()->setLocalCacheMaxSize(mCacheMaxSize);
    regovar->settings()->save();
    emit cacheMaxSizeChanged();
}




File* FilesManager::getOrCreateFile(int id)
{
    if (!mFiles.contains(id))
    {
        // Create new file
        mFiles.insert(id, new File(id, this));
    }
    return mFiles[id];
}



File* FilesManager::getFile(int id)
{
    if (!mFiles.contains(id))
    {
        return nullptr;
    }

    // get file and force refresh if needed
    File* file = mFiles[id];
    file->load(false);

    return file;
}



bool FilesManager::deleteFile(int id)
{
    if (mFiles.contains(id))
    {
        // Remove local instance of the file
        File* file = mFiles[id];
        mFiles.remove(id);
        mRemoteFilesList->remove(file);
        file->clearCache();

        // Remove the file on the server
        Request* req = Request::del(QString("/file/%1").arg(id));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                // All is done, notify the view
                emit remoteListChanged();
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
    else
    {
        return false;
    }
    return true;
}



void FilesManager::loadFilesBrowser()
{
    Request* req = Request::get(QString("/files"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mRemoteFilesList->clear();
            for (const QJsonValue& data: json["data"].toArray())
            {
                QJsonObject fileData = data.toObject();
                File* file = getOrCreateFile(fileData["id"].toInt());
                file->loadJson(fileData);
                mRemoteFilesList->append(file);
            }
            emit remoteListChanged();
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
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
    for (const QString& key: mapping.keys())
    {
        // retrieve file id into the mapping url
        QStringList pathSplitted = mapping[key].split("/");
        int id = pathSplitted[pathSplitted.count()-1].toInt();
        File* file = getOrCreateFile(id);
        file->load();
        mUploadsList->append(file);

        // Store in QSettings to be able to resume upload if interrupted
        regovar->settings()->addUploadFile(id, key);

        emit fileUploadEnqueued(key, id);
        // qDebug() << key << " => " << mapping[key] << id;
    }
    updateUploadProgress();
}



void FilesManager::cancelUploadFile(QList<int> filesId)
{
    for (const int id: filesId)
    {
        if (mFiles.contains(id))
        {
            File* file = mFiles[id];
            if (mUploadsList->contains(file))
            {
                mUploader->cancel(QString::number(id));
                mUploadsList->remove(file);
                // Remove from QSettings
                regovar->settings()->removeUploadFile(id);
            }
        }
    }
    updateUploadProgress();
}


void FilesManager::clearUploadsList()
{
    mUploadsList->clear();
    regovar->settings()->clearUploadFile();
}



void FilesManager::refreshCacheStats()
{
    mCacheOccupiedSize = 0;
    QFileInfo info(mCacheDir);

    if (info.isDir())
    {
        mCacheOccupiedSize = directorySize(mCacheDir);
    }
    emit cacheOccupiedSizeChanged();
}

qint64 FilesManager::directorySize(const QString path)
{
    qint64 size = 0;
    QFileInfo info(path);
    if (info.isDir())
    {
        QDir dir(path);
        dir.setFilter(QDir::Files | QDir::Dirs |  QDir::Hidden | QDir::NoSymLinks);
        QFileInfoList list = dir.entryInfoList();


        for(int i=0; i < list.size(); ++i)
        {
            QFileInfo fileInfo = list.at(i);
            if (fileInfo.fileName() != "." && fileInfo.fileName() != "..")
            {
                size += fileInfo.size();
            }
        }
    }
    return size;
}


void FilesManager::clearCache()
{
    QDir dir(mCacheDir);

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    for(const QString dirItem: dir.entryList())
    {
        dir.remove( dirItem );
    }

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
    for(const QString dirItem: dir.entryList())
    {
        QDir subDir(dir.absoluteFilePath(dirItem));
        subDir.removeRecursively();
    }
}


void FilesManager::pauseUpload(int fileId)
{
    mUploader->pause(QString::number(fileId));
}
void FilesManager::startUpload(int fileId)
{
    mUploader->start(QString::number(fileId));
}
void FilesManager::cancelUpload(int fileId)
{
    mUploader->cancel(QString::number(fileId));
    deleteFile(fileId);
}



void FilesManager::processPushNotification(QString action, QJsonObject json)
{
    if (action == "file_upload")
    {
        // update file information
        int id = json["id"].toInt();
        File* file = getOrCreateFile(id);
        file->loadJson(json);
        // update global upload progress
        if (mUploadsList->contains(file))
        {
            updateUploadProgress();
        }
    }
}



void FilesManager::updateUploadProgress()
{
    if (mUploadsList->rowCount() > 0)
    {
        int totalProgress = 0;
        for (int idx=0; idx < mUploadsList->rowCount(); idx++)
        {
            File* f = mUploadsList->getAt(idx);
            int progress = 0;
            double s = f->size();
            if (s>0) progress = f->uploadOffset() / s * 100;
            totalProgress += progress;

            if (f->size() != 0 && f->uploadOffset() == f->size())
            {
                // Remove from QSettings
                regovar->settings()->removeUploadFile(f->id());
            }
        }
        mUploadsProgress = totalProgress / mUploadsList->rowCount();
    }
    emit uploadsChanged();
}
