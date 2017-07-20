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
    QString uid;
    QUrl uploadUrl;
    QString path;
    QFile* file;
    quint64 size;
    quint64 offset;
};

class TusUploader : public QObject
{
    Q_OBJECT
public:
    explicit TusUploader(QObject *parent = nullptr);
    ~TusUploader();

    // Accessors
    inline QString uploadUrl() { return mTusUploadUrl; }

    // Setters
    inline void setUploadUrl(QString url) { mTusUploadUrl = url; }

    // Methods
    void loadSettings();
    void writteSettings();
    void enqueue(QString path);
    void pause(QString path);
    void cancel(QString path);
    void start(QString path);




signals:

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
    QString mTusUploadUrl;
    int mChunkSize;
    int mBandWidthLimit;
    int mMaxUpload;

    QNetworkAccessManager mNetManager;
    QQueue<TusUploadItem> mQueue;
    QList<TusUploadItem> mInProgress;
    QHash<QNetworkReply*, TusUploadItem*> mRequestHash;

};

#endif // TUSUPLOADER_H
