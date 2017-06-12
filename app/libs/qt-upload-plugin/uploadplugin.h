#ifndef DOWNLOADPLUGIN_H
#define DOWNLOADPLUGIN_H

#include "uploadinterface.h"
#include <QObject>
#include <QtPlugin>
#include <QNetworkAccessManager>
#include <QQueue>
#include <QUrl>
#include <QTime>
#include <QSet>
#include <QString>
#include <QFile>
#include <QHash>
#include <QStringList>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSslError>
#include <QHttpMultiPart>


/**
 * Upload item is several variables about an upload.
 * Used in upload queue.
 */
struct UploadItem {
    QString key;
    QString path;
    QString submitUrl;
    QFile *file;
    QTime time;
    int stage;
    int chunkCounter;
    bool isResume;
    qint64 size;
    qint64 start;
    qint64 end;
    qint64 sent;
    QByteArray historyId;
};

/**
 * UploadInterface implementation.
 * \see UploadInterface for detailed comments about Upload plugin.
 */
class UploadPlugin : public UploadInterface
{
    Q_OBJECT
    Q_INTERFACES(UploadInterface)

public:
    UploadPlugin(QObject * parent = 0);
    ~UploadPlugin();

    QString name() const;
    QString version() const;
    void setDefaultParameters();

    void append(const QString &path);
    void append(const QStringList &pathList);

    void pause(const QString &path);
    void pause(const QStringList &pathList);

    void resume(const QString &path, const QString &submitUrl = "");
    void resume(const QList<UploadResumePair> & pathList);

    void stop(const QString &path);
    void stop(const QStringList &pathList);

    void setBandwidthLimit(int bytesPerSecond);

private slots:
    void startNextUpload();

    /**
     * Slots for QNetworkReply.
     */
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadFinished();
    void uploadError(QNetworkReply::NetworkError);
    void uploadSslErrors(QList<QSslError>);

private:
    void stopUpload(const QString &url, bool pause);
    void connectSignals(QNetworkReply *reply);
    void uploadChunk(QNetworkReply *reply);

private:
    QNetworkAccessManager manager;
    QQueue<UploadItem> uploadQueue;
    QHash<QNetworkReply*, UploadItem> uploadHash;
    QHash<QString, QNetworkReply*> urlHash;
    QList<UploadItem> completedList;
};

#endif // DOWNLOADPLUGIN_H
