#ifndef FILESMANAGER_H
#define FILESMANAGER_H

#include <QObject>
#include "filestreemodel.h"
#include "tusuploader.h"

class FilesManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<QObject*> uploadsList READ uploadsList NOTIFY uploadsChanged)
    Q_PROPERTY(int uploadsProgress READ uploadsProgress NOTIFY uploadsChanged)

    Q_PROPERTY(QList<QObject*> remoteList READ remoteList NOTIFY remoteListChanged)
    Q_PROPERTY(FilesTreeModel* filesTree READ filesTree NOTIFY filesTreeChanged)



public:
    explicit FilesManager(QObject *parent = nullptr);

    // Getters
    inline int uploadsProgress() const { return mUploadsProgress; }
    inline QList<QObject*> remoteList() const { return mRemoteFilesList; }
    inline QList<QObject*> uploadsList() const { return mUploadsList; }
    inline FilesTreeModel* filesTree() const { return mFilesTree; }

    // Method
    Q_INVOKABLE void loadFilesBrowser();
    Q_INVOKABLE void enqueueUploadFile(QStringList filesPaths);
    Q_INVOKABLE void cancelUploadFile(QStringList filesPaths);


public Q_SLOTS:
    void filesEnqueued(QHash<QString,QString> mapping);


Q_SIGNALS:
    void uploadsChanged();
    void remoteListChanged();
    void filesTreeChanged();

private:
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
};

#endif // FILESMANAGER_H
