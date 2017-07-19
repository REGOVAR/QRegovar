/*********************************************************************
** Copyright © 2013 Nurul Arif Setiawan <n.arif.setiawan@gmail.com>
** All rights reserved.
**
** See the file "LICENSE.txt" for the full license governing this code
**
**********************************************************************/

#include "downloadplugin.h"

#include <QDebug>
#include <QFile>
#include <QUuid>
#include <QFileInfo>
#include <QTimer>
#include <QDesktopServices>

DownloadPlugin::DownloadPlugin(QObject * parent)
    : DownloadInterface (parent)
{

}

DownloadPlugin::~DownloadPlugin()
{

}

QString DownloadPlugin::name() const
{
    return "DownloadPlugin";
}

QString DownloadPlugin::version() const
{
    return "1.0";
}

void DownloadPlugin::setDefaultParameters()
{
    m_existPolicy = DownloadInterface::ExistThenOverwrite;
    m_partialPolicy = DownloadInterface::PartialThenContinue;
    m_userAgent = "DownloadPlugin/0.0.2";
    m_bandwidthLimit = 30*1024;
    m_queueSize = 2;
    m_filePath = QStandardPaths::DocumentsLocation;
}

void DownloadPlugin::append(const QString &url)
{
    appendInternal(url);
}

void DownloadPlugin::append(const QStringList &urlList)
{
    foreach (QString url, urlList){
        append(url);
    }

    if (downloadQueue.isEmpty())
        QTimer::singleShot(0, this, SIGNAL(finished()));
}

void DownloadPlugin::pause(const QString &url)
{
    stopDownload(url, true);
}

void DownloadPlugin::pause(const QStringList &urlList)
{
    foreach (QString url, urlList){
        pause(url);
    }
}

void DownloadPlugin::resume(const QString &url, const QString &path)
{
    appendInternal(url, path);
}

void DownloadPlugin::resume(const QList<DownloadResumePair> & urlList)
{
    foreach (DownloadResumePair downloadPair, urlList){
        resume(downloadPair.first, downloadPair.second);
    }
}

void DownloadPlugin::stop(const QString &url)
{
    stopDownload(url, false);
}

void DownloadPlugin::stop(const QStringList &urlList)
{
    foreach (QString url, urlList){
        stop(url);
    }
}

void DownloadPlugin::appendInternal(const QString &url, const QString &path)
{
    bool fileExist = false;
    bool tempExist = false;
    QString fileName = "";
    QString filePath = saveFilename(path == "" ? url : path, fileExist, fileName, tempExist, path == "");

    if (fileExist && m_existPolicy == DownloadInterface::ExistThenCancel) {
        qDebug() << fileName << "exist. Cancel download";
        emit status(url, "Cancel", "File already exist", filePath);
        return;
    }

    DownloadItem item;
    item.url = url;
    item.key = fileName;
    item.path = filePath;
    item.temp = filePath + ".part";
    item.tempExist = tempExist;

    if (downloadQueue.isEmpty())
        QTimer::singleShot(0, this, SLOT(startNextDownload()));

    downloadQueue.enqueue(item);
}

void DownloadPlugin::stopDownload(const QString &url, bool pause)
{
    QNetworkReply *reply = urlHash[url];

    if (reply) {
        disconnect(reply, SIGNAL(downloadProgress(qint64,qint64)),
                this, SLOT(downloadProgress(qint64,qint64)));
        disconnect(reply, SIGNAL(finished()),
                this, SLOT(downloadFinished()));
        disconnect(reply, SIGNAL(readyRead()),
                this, SLOT(downloadReadyRead()));
        disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(downloadError(QNetworkReply::NetworkError)));
        disconnect(reply, SIGNAL(sslErrors(QList<QSslError>)),
                this, SLOT(downloadSslErrors(QList<QSslError>)));

        DownloadItem item = downloadHash[reply];
        reply->abort();
        item.file->write( reply->readAll());
        item.file->close();

        if (!pause) {
            QFile::remove(item.temp);
        }

        downloadHash.remove(reply);
        urlHash.remove(url);

        startNextDownload();

        reply->deleteLater();
    }
}

void DownloadPlugin::startNextDownload()
{
    if (downloadQueue.isEmpty()) {
        emit queueEmpty();
        return;
    }

    if (downloadHash.size() < m_queueSize)
    {
        DownloadItem item = downloadQueue.dequeue();

        QNetworkRequest request(item.url);
        request.setRawHeader("User-Agent", m_userAgent);

        if (item.tempExist && m_partialPolicy == DownloadInterface::PartialThenContinue) {
            item.file = new QFile(item.temp);
            if (!item.file->open(QIODevice::ReadWrite)) {
                qDebug() << "Download error" << item.file->errorString();
                emit status(item.url, "Error", item.file->errorString(), item.path);
                startNextDownload();
                return;
            }
            item.file->seek(item.file->size());
            item.tempSize = item.file->size();
            QByteArray rangeHeaderValue = "bytes=" + QByteArray::number(item.tempSize) + "-";
            request.setRawHeader("Range",rangeHeaderValue);
        }
        else {
            if (item.tempExist) {
                QFile::remove(item.temp);
            }

            item.file = new QFile(item.temp);
            if (!item.file->open(QIODevice::ReadWrite)) {
                qDebug() << "Download error" << item.file->errorString();
                emit status(item.url, "Error", item.file->errorString(), item.path);
                startNextDownload();
                return;
            }
            item.tempSize = 0;
        }

        QNetworkReply *reply = manager.get(request);
        connect(reply, SIGNAL(downloadProgress(qint64,qint64)),
                this, SLOT(downloadProgress(qint64,qint64)));
        connect(reply, SIGNAL(finished()),
                this, SLOT(downloadFinished()));
        connect(reply, SIGNAL(readyRead()),
                this, SLOT(downloadReadyRead()));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(downloadError(QNetworkReply::NetworkError)));
        connect(reply, SIGNAL(sslErrors(QList<QSslError>)),
                this, SLOT(downloadSslErrors(QList<QSslError>)));

        qDebug() << "startNextDownload" << item.url << item.temp;
        emit status(item.url, "Download", "Start downloading file", item.url);

        item.time.start();
        downloadHash[reply] = item;
        urlHash[item.url] = reply;

        startNextDownload();
    }
}

void DownloadPlugin::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());

    if (reply->error() == QNetworkReply::NoError) {

        DownloadItem item = downloadHash[reply];

        qint64 actualReceived = item.tempSize + bytesReceived;
        qint64 actualTotal = item.tempSize + bytesTotal;
        double speed = actualReceived * 1000.0 / item.time.elapsed();
        QString unit;
        if (speed < 1024) {
            unit = "bytes/sec";
        } else if (speed < 1024*1024) {
            speed /= 1024;
            unit = "kB/s";
        } else {
            speed /= 1024*1024;
            unit = "MB/s";
        }
        int percent = actualReceived * 100 / actualTotal;

        //qDebug() << "downloadProgress" << item.url << bytesReceived << bytesTotal << percent << speed << unit;
        emit progress(item.url, actualReceived, actualTotal, percent, speed, unit);
    }
}

void DownloadPlugin::downloadReadyRead()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    DownloadItem item = downloadHash[reply];
    item.file->write(reply->readAll());
}

void DownloadPlugin::downloadFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());

    if (reply->error() == QNetworkReply::NoError) {

        DownloadItem item = downloadHash[reply];

        item.file->close();
        item.file->deleteLater();

        if (QFile::exists(item.path))
            QFile::remove(item.path);
        QFile::rename(item.temp, item.path);
        completedList.append(item);
        qDebug() << "downloadFinished" << item.url << item.path;

        emit status(item.url, "Complete", "Download file completed", item.url);
        emit finished(item.url, item.path);

        downloadHash.remove(reply);
        urlHash.remove(item.url);

        startNextDownload();
    }

    reply->deleteLater();
}

void DownloadPlugin::downloadError(QNetworkReply::NetworkError)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    DownloadItem item = downloadHash[reply];
    qDebug() << "downloadError: " << item.url << reply->errorString() << reply;

    emit status(item.url, "Error", reply->errorString(), item.url);
    emit progress(item.url, 0, 0, 0, 0, "bytes/sec");

    // remove download when error
    downloadHash.remove(reply);
    urlHash.remove(item.url);

    startNextDownload();
}

void DownloadPlugin::downloadSslErrors(QList<QSslError>)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    reply->ignoreSslErrors();
}

void DownloadPlugin::setBandwidthLimit(int bytesPerSecond)
{
    m_bandwidthLimit = bytesPerSecond;
    // TODO :: implement rate controller
}

QString DownloadPlugin::saveFilename(const QString &url, bool &exist, QString &fileName, bool &tempExist, bool isUrl)
{
    QFileInfo fi = QFileInfo(url);
    QString basename = fi.baseName();
    QString suffix = fi.completeSuffix();

    if (basename.isEmpty())
        basename = QUuid::createUuid().toString();

    QString filePath = url;
    fileName = fi.fileName();
    if (isUrl){
        filePath = m_filePath + "/" + basename + "." + suffix;
        fileName = basename + "." + suffix;
    }

    // check if complete file exist
    if (QFile::exists(filePath))
    {
        exist = true;
        if (m_existPolicy == DownloadInterface::ExistThenRename) {
            qDebug() << "File" << filePath << "exist. Rename";
            int i = 0;
            basename += '(';
            while (QFile::exists(m_filePath + "/" + basename + "(" + QString::number(i) + ")" + suffix))
                ++i;

            basename += QString::number(i) + ")";
            filePath = m_filePath + "/" + basename + "." + suffix;
        }
        else if (m_existPolicy == DownloadInterface::ExistThenOverwrite) {
            qDebug() << "File" << filePath << "exist. Overwrite";
            QFile::remove(filePath);
        }
    }

    emit filenameSet(url, filePath);

    // check if part file exist
    QString filePart = filePath + ".part";
    if (QFile::exists(filePart))
    {
        tempExist = true;
    }

    return filePath;
}
