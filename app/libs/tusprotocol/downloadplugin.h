/*********************************************************************
** Copyright © 2013 Nurul Arif Setiawan <n.arif.setiawan@gmail.com>
** All rights reserved.
**
** See the file "LICENSE.txt" for the full license governing this code
**
**********************************************************************/

#ifndef DOWNLOADPLUGIN_H
#define DOWNLOADPLUGIN_H

#include "downloadinterface.h"
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

/**
 * Download item is several variables about a download.
 * Used in download queue.
 */
struct DownloadItem{
    QString key;
    QString url;
    QString path;
    QString temp;
    QFile *file;
    QTime time;
    bool tempExist;
    qint64 tempSize;
};

/**
 * DownloadInterface implementation.
 * \see DownloadInterface for detailed comments about Download plugin.
 */
class DownloadPlugin : public DownloadInterface
{
    Q_OBJECT
    Q_INTERFACES(DownloadInterface)

public:
    DownloadPlugin(QObject * parent = 0);
    ~DownloadPlugin();

    QString name() const;
    QString version() const;
    void setDefaultParameters();

    void append(const QString &url);
    void append(const QStringList &urlList);

    void pause(const QString &url);
    void pause(const QStringList &urlList);

    void resume(const QString &url, const QString &path = "");
    void resume(const QList<DownloadResumePair> & urlList);

    void stop(const QString &url);
    void stop(const QStringList &urlList);

    void setBandwidthLimit(int bytesPerSecond);

private slots:
    void startNextDownload();

    /**
     * Slots for QNetworkReply.
     */
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void downloadReadyRead();
    void downloadFinished();
    void downloadError(QNetworkReply::NetworkError);
    void downloadSslErrors(QList<QSslError>);

private:
    void appendInternal(const QString &url, const QString &path = "");
    void stopDownload(const QString &url, bool pause);
    QString saveFilename(const QString &url, bool &exist, QString &fileName, bool &tempExist, bool isUrl);

private:
    QNetworkAccessManager manager;
    QQueue<DownloadItem> downloadQueue;
    QHash<QNetworkReply*, DownloadItem> downloadHash;
    QHash<QString, QNetworkReply*> urlHash;
    QList<DownloadItem> completedList;
};

#endif // DOWNLOADPLUGIN_H
