#ifndef FILESMANAGER_H
#define FILESMANAGER_H

#include <QObject>
#include "file.h"
#include "filestreemodel.h"
#include "tusuploader.h"

class FilesManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cacheDir READ cacheDir WRITE setCacheDir NOTIFY cacheDirChanged)
    Q_PROPERTY(qint64 cacheOccupiedSize READ cacheOccupiedSize WRITE setCacheOccupiedSize NOTIFY cacheOccupiedSizeChanged)
    Q_PROPERTY(int cacheMaxSize READ cacheMaxSize WRITE setCacheMaxSize NOTIFY cacheMaxSizeChanged)
    Q_PROPERTY(QList<QObject*> uploadsList READ uploadsList NOTIFY uploadsChanged)
    Q_PROPERTY(int uploadsProgress READ uploadsProgress NOTIFY uploadsChanged)

    Q_PROPERTY(QList<QObject*> remoteList READ remoteList NOTIFY remoteListChanged)
    Q_PROPERTY(FilesTreeModel* filesTree READ filesTree NOTIFY filesTreeChanged)



public:
    // Constructor
    FilesManager(QObject *parent = nullptr);

    // Getters
    inline QString cacheDir() const { return mCacheDir; }
    inline qint64 cacheOccupiedSize() const { return mCacheOccupiedSize; }
    inline int cacheMaxSize() const { return mCacheMaxSize; }
    inline int uploadsProgress() const { return mUploadsProgress; }
    inline QList<QObject*> remoteList() const { return mRemoteFilesList; }
    inline QList<QObject*> uploadsList() const { return mUploadsList; }
    inline FilesTreeModel* filesTree() const { return mFilesTree; }

    // Setters
    void setCacheDir(QString path);
    inline void setCacheOccupiedSize(int size) { mCacheOccupiedSize = size; emit cacheOccupiedSizeChanged(); }
    void setCacheMaxSize(int size);

    // Method
    Q_INVOKABLE File* getOrCreateFile(int id);
    Q_INVOKABLE File* getFile(int id);
    Q_INVOKABLE bool deleteFile(int id);
    Q_INVOKABLE void loadFilesBrowser();
    Q_INVOKABLE void enqueueUploadFile(QStringList filesPaths);
    Q_INVOKABLE void cancelUploadFile(QList<int> filesId);
    Q_INVOKABLE void clearUploadsList();
    Q_INVOKABLE void refreshCacheStats();
    Q_INVOKABLE void clearCache();
    Q_INVOKABLE void pauseUpload(int id);
    Q_INVOKABLE void cancelUpload(int id);
    Q_INVOKABLE void startUpload(int id);
    void processPushNotification(QString action, QJsonObject json);
    void updateUploadProgress();
    qint64 directorySize(const QString path);


public Q_SLOTS:
    void filesEnqueued(QHash<QString,QString> mapping);


Q_SIGNALS:
    void cacheDirChanged();
    void cacheOccupiedSizeChanged();
    void cacheMaxSizeChanged();
    void uploadsChanged();
    void remoteListChanged();
    void filesTreeChanged();
    void fileUploadEnqueued(QString localPath, int fileId);

private:
    //! internal hash map of all files. Will keep ref to all file loaded even if they are no more displayed
    QHash<int, File*> mFiles;
    //! The progress (0 to 100) of all uploads
    int mUploadsProgress = 0;
    //! The list of files that are currently uploadling (by this client, add file with enqueueUploadFile method)
    QList<QObject*> mUploadsList;
    //! The flat list of files available on the server (load/init with loadFilesBrowser method)
    QList<QObject*> mRemoteFilesList;
    //! The tree list of files available on the server (load/init with loadFilesBrowser method)
    FilesTreeModel* mFilesTree = nullptr;
    //! The uploader that manage TUS protocol (resumable upload)
    TusUploader * mUploader = nullptr;
    //! The path to the local cache folder
    QString mCacheDir;
    //! The current size of the cache folder (in bytes)
    qint64 mCacheOccupiedSize = 0;
    //! The maximum size of the cache folder (in giga)
    int mCacheMaxSize = 20;
};

#endif // FILESMANAGER_H
