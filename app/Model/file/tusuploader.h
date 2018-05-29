#ifndef TUSUPLOADER_H
#define TUSUPLOADER_H


#include <QQueue>
#include <QFile>
#include <QString>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSslError>

struct TusUploadItem
{
    QString uploadUrl;
    QString path;
    QString fileId;
    QFile* file = nullptr;
    quint64 size = 0;
    quint64 offset = 0;
    bool prepareFlag = false;
    bool paused = false;
};

class TusUploader : public QObject
{
    Q_OBJECT
public:
    // Constructors
    TusUploader(QObject *parent = nullptr);
    ~TusUploader();

    // Accessors
    inline QString uploadUrl() { return mTusUploadUrl; }
    inline QString rootUrl() { return mTusRootUrl; }
    inline int chunkSize() { return mChunkSize; }
    inline int bandWidthLimit() { return mBandWidthLimit; }

    // Setters
    inline void setUploadUrl(QString url) { mTusUploadUrl = url; }
    inline void setRootUrl(QString url) { mTusRootUrl = url; }
    inline void setChunkSize(int value) { mChunkSize = value; }
    inline void setBandWidthLimit(int value) { mBandWidthLimit = value; }

    // Methods
    void loadSettings();
    void writteSettings();
    void enqueue(QStringList paths);    //! Register file to the server, enqueue them and start upload as soon as possible
    void pause(QString fileId);         //! Suspend upload for the file
    void cancel(QString fileId);        //! Cancel upload for the file
    void start(QString fileId);         //! Start/Resume upload for the file that have been paused
    void emitFileEnqueued(QHash<QString, QString>* serverMapping);


Q_SIGNALS:
    void uploadStarted(TusUploadItem* file);
    void uploadEnded(TusUploadItem* file);
    void filesEnqueued(QHash<QString, QString> serverMapping);


public Q_SLOTS:
    //! Try to start or resume uploads in the queue
    void startNext();
    void newUploadFinished();
    void resumeUploadFinished();
    void patchUploadFinished();
    void uploadError(QNetworkReply::NetworkError);
    void uploadSslErrors(QList<QSslError>);

protected:
    void resumeUpload(TusUploadItem* file);
    void patchUpload(TusUploadItem* file);
    void serverConfig();
    void newUpload(TusUploadItem* item);
    void cancelUpload(TusUploadItem* item);
    QString base64Encode(QString string);
    void connectErrorSignals(QNetworkReply* reply);

private:
    QByteArray mUserAgent;
    QByteArray mTusVersion;
    QString mTusRootUrl;
    QString mTusUploadUrl;
    int mChunkSize = 0;
    int mBandWidthLimit = 0;
    int mMaxUpload = 2;

    QNetworkAccessManager mNetManager;
    QQueue<TusUploadItem*> mQueue;
    QList<TusUploadItem*> mInProgress;
    QHash<QNetworkReply*, TusUploadItem*> mRequestHash;

};

#endif // TUSUPLOADER_H
