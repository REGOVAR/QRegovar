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
    QFile* file;
    quint64 size;
    quint64 offset;
    bool prepareFlag;
};

class TusUploader : public QObject
{
    Q_OBJECT
public:
    explicit TusUploader(QObject *parent = nullptr);
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
    void enqueue(QStringList paths); //! Register file to the server, enqueue them and start upload as soon as possible
    void pause(QString path);           //! Suspend upload for the file
    void cancel(QString path);          //! Cancel upload for the file
    void start(QString path);           //! Start/Resume upload for the file
    void emitFileEnqueued(QHash<QString, QString>* serverMapping);



signals:
    void uploadStarted(TusUploadItem* file);
    void uploadEnded(TusUploadItem* file);
    void filesEnqueued(QHash<QString, QString> serverMapping);

public slots:
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
    int mChunkSize;
    int mBandWidthLimit;
    int mMaxUpload;

    QNetworkAccessManager mNetManager;
    QQueue<TusUploadItem*> mQueue;
    QList<TusUploadItem*> mInProgress;
    QHash<QNetworkReply*, TusUploadItem*> mRequestHash;

};

#endif // TUSUPLOADER_H
