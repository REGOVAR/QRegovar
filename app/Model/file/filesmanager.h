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
    Q_PROPERTY(qint64 cacheSize READ cacheSize WRITE setCacheSize NOTIFY cacheSizeChanged)
    Q_PROPERTY(int cacheMaxSize READ cacheMaxSize WRITE setCacheMaxSize NOTIFY cacheMaxSizeChanged)
    Q_PROPERTY(QList<QObject*> uploadsList READ uploadsList NOTIFY uploadsChanged)
    Q_PROPERTY(int uploadsProgress READ uploadsProgress NOTIFY uploadsChanged)

    Q_PROPERTY(QList<QObject*> remoteList READ remoteList NOTIFY remoteListChanged)
    Q_PROPERTY(FilesTreeModel* filesTree READ filesTree NOTIFY filesTreeChanged)



public:
    explicit FilesManager(QObject *parent = nullptr);

    // Getters
    inline QString cacheDir() const { return mCacheDir; }
    inline qint64 cacheSize() const { return mCacheSize; }
    inline int cacheMaxSize() const { return mCacheMaxSize; }
    inline int uploadsProgress() const { return mUploadsProgress; }
    inline QList<QObject*> remoteList() const { return mRemoteFilesList; }
    inline QList<QObject*> uploadsList() const { return mUploadsList; }
    inline FilesTreeModel* filesTree() const { return mFilesTree; }

    // Setters
    inline void setCacheDir(QString path) { mCacheDir = path; refreshCacheStats(); emit cacheDirChanged(); }
    inline void setCacheSize(int size) { mCacheSize = size; emit cacheSizeChanged(); }
    inline void setCacheMaxSize(int size) { mCacheMaxSize = size; emit cacheMaxSizeChanged(); }

    // Method
    Q_INVOKABLE File* getOrCreateFile(int id);
    Q_INVOKABLE void loadFilesBrowser();
    Q_INVOKABLE void enqueueUploadFile(QStringList filesPaths);
    Q_INVOKABLE void cancelUploadFile(QList<int> filesId);
    Q_INVOKABLE void clearUploadsList();
    Q_INVOKABLE void refreshCacheStats();
    Q_INVOKABLE void clearCache();
    void processPushNotification(QString action, QJsonObject json);
    void updateUploadProgress();
    qint64 directorySize(const QString path);


public Q_SLOTS:
    void filesEnqueued(QHash<QString,QString> mapping);


Q_SIGNALS:
    void cacheDirChanged();
    void cacheSizeChanged();
    void cacheMaxSizeChanged();
    void uploadsChanged();
    void remoteListChanged();
    void filesTreeChanged();

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
    qint64 mCacheSize = 0;
    //! The maximum size of the cache folder (in giga)
    int mCacheMaxSize = 20;
};

#endif // FILESMANAGER_H
