#include "uploadplugin.h"

#include <QtCore/qplugin.h>
#include <QDebug>
#include <QFile>
#include <QUuid>
#include <QFileInfo>
#include <QTimer>
#include <QBuffer>

UploadPlugin::UploadPlugin(QObject * parent)
    : UploadInterface (parent)
{

}

UploadPlugin::~UploadPlugin()
{

}

QString UploadPlugin::name(void) const
{
    return "UploadPlugin";
}

QString UploadPlugin::version() const
{
    return "1.0";
}

void UploadPlugin::setDefaultParameters()
{
    m_uploadProtocol = UploadInterface::ProtocolTus;
    m_userAgent = "UploadPlugin/0.0.2";
    m_chunkSize = 50*1024;
    m_bandwidthLimit = 30*1024;
    m_queueSize = 2;
    m_patchVerb = "PATCH";
}

void UploadPlugin::append(const QString &path)
{
    QFileInfo fi(path);

    qDebug() << "upload append" << path;

    UploadItem item;
    item.key = fi.fileName();
    item.path = path;
    item.isResume = false;

    if (uploadQueue.isEmpty())
        QTimer::singleShot(0, this, SLOT(startNextUpload()));

    uploadQueue.enqueue(item);
}

void UploadPlugin::append(const QStringList &pathList)
{
    foreach (QString path, pathList){
        append(path);
    }

    if (uploadQueue.isEmpty())
        QTimer::singleShot(0, this, SIGNAL(queueEmpty()));
}

void UploadPlugin::pause(const QString &path)
{
    stopUpload(path, true);
}

void UploadPlugin::pause(const QStringList &pathList)
{
    foreach (QString path, pathList){
        pause(path);
    }
}

void UploadPlugin::resume(const QString &path, const QString &submitUrl)
{
    QFileInfo fi(path);

    qDebug() << "upload append resume" << path;

    UploadItem item;
    item.key = fi.fileName();
    item.path = path;
    item.isResume = true;
    item.submitUrl = submitUrl;

    if (uploadQueue.isEmpty())
        QTimer::singleShot(0, this, SLOT(startNextUpload()));

    uploadQueue.enqueue(item);
}

void UploadPlugin::resume(const QList<UploadResumePair> & pathList)
{
    foreach (UploadResumePair uploadPair, pathList){
        resume(uploadPair.first, uploadPair.second);
    }
}

void UploadPlugin::stop(const QString &path)
{
    stopUpload(path, false);
}

void UploadPlugin::stop(const QStringList &pathList)
{
    foreach (QString path, pathList){
        stop(path);
    }
}

void UploadPlugin::stopUpload(const QString &path, bool pause)
{
    QNetworkReply *reply = urlHash[path];

    if (reply) {
        qDebug() << "DISCONNECT" << reply;

        disconnect(reply, SIGNAL(uploadProgress(qint64,qint64)),
                this, SLOT(uploadProgress(qint64,qint64)));
        disconnect(reply, SIGNAL(finished()),
                this, SLOT(uploadFinished()));
        disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(uploadError(QNetworkReply::NetworkError)));
        disconnect(reply, SIGNAL(sslErrors(QList<QSslError>)),
                this, SLOT(uploadSslErrors(QList<QSslError>)));

        UploadItem item = uploadHash[reply];
        reply->abort();

        uploadHash.remove(reply);
        urlHash.remove(item.path);

        startNextUpload();

        reply->deleteLater();
    }
}

void UploadPlugin::connectSignals(QNetworkReply *reply)
{
    connect(reply, SIGNAL(uploadProgress(qint64,qint64)),
            this, SLOT(uploadProgress(qint64,qint64)));
    connect(reply, SIGNAL(finished()),
            this, SLOT(uploadFinished()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(uploadError(QNetworkReply::NetworkError)));
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)),
            this, SLOT(uploadSslErrors(QList<QSslError>)));
}

void UploadPlugin::uploadChunk(QNetworkReply *reply)
{
    UploadItem item = uploadHash[reply];

    if (item.chunkCounter == 0)
    {
        if (item.isResume)
        {
            item.time.start();
        }
        else
        {
            item.time.start();
            // init with zero
            item.start = 0;
        }
    }

    if (item.start < item.size)
    {
        qDebug() << "START CHUNK " << item.chunkCounter;

        item.end = item.start + m_chunkSize;
        if (item.end > item.size)
        {
            item.end = item.size;
        }

        qint64 size = item.end - item.start;
        item.sent = item.start;

        //qDebug() << item.start << item.end;

        QByteArray offset;
        offset.setNum(item.start);

        QByteArray length;
        length.setNum(item.end - item.start);

        uchar *buf = item.file->map(item.start, size);
        QBuffer * buffer = new QBuffer();
        buffer->setData(reinterpret_cast<const char*>(buf), size);
        buffer->close();

        QNetworkRequest request(QUrl(item.submitUrl));
        request.setRawHeader("User-Agent", m_userAgent);
        request.setRawHeader("Connection", "keep-alive");
        request.setRawHeader("Offset", offset);
        request.setRawHeader("Content-Length", length);
        request.setRawHeader("Content-Type", "application/offset+octet-stream");

        if (item.historyId.length() > 0)
        {
            request.setRawHeader("History-Id", item.historyId);
        }

        // remove previous reply
        uploadHash.remove(reply);

        // default verb
        m_patchVerb = m_patchVerb.length() == 0 ? "PATCH" : m_patchVerb;

        QNetworkReply * reply = manager.sendCustomRequest(request, m_patchVerb, buffer);
        connectSignals(reply);

        item.file->unmap(buf);
        item.start += size;

        uploadHash[reply] = item;
        urlHash[item.path] = reply;
    }
    else
    {
        qDebug() << "DONE. Uploaded" << item.path << "to" << item.submitUrl;
        item.file->close();
        item.file->deleteLater();

        completedList.append(item);

        emit status(item.path, "Complete", "Upload file completed", item.submitUrl);
        emit finished(item.path, item.submitUrl);

        uploadHash.remove(reply);
        urlHash.remove(item.path);

        startNextUpload();
    }
}

void UploadPlugin::startNextUpload()
{
    if (uploadQueue.isEmpty()) {
        emit queueEmpty();
        return;
    }

    if (uploadHash.size() < m_queueSize)
    {
        UploadItem item = uploadQueue.dequeue();

        if (m_uploadProtocol == UploadInterface::ProtocolTus)
        {
            if (item.isResume)
            {
                item.file = new QFile(item.path);
                item.file->open(QIODevice::ReadOnly);
                item.size = item.file->size();
                item.stage = 0;
                item.sent = 0;
                item.start = 0;

                qDebug() << item.submitUrl;

                QNetworkRequest request(QUrl(item.submitUrl));
                request.setRawHeader("User-Agent", m_userAgent);

                QNetworkReply * reply = manager.head(request);
                connectSignals(reply);

                //qDebug() << "START" << reply;

                emit status(item.path, "Resume", "Start resume upload file", m_uploadUrl.toString());

                uploadHash[reply] = item;
                urlHash[item.path] = reply;
            }
            else
            {
                item.file = new QFile(item.path);
                item.file->open(QIODevice::ReadOnly);
                item.size = item.file->size();
                item.stage = 0;
                item.sent = 0;
                item.start = 0;

                QNetworkRequest request(m_uploadUrl);
                request.setRawHeader("User-Agent", m_userAgent);
                QByteArray fileLength;
                fileLength.setNum(item.size);
                request.setRawHeader("Final-Length", fileLength);
                QByteArray contentLength;
                contentLength.setNum(0);
                request.setRawHeader("Content-Length", contentLength);
                request.setRawHeader("Content-Type", "application/octet-stream");

                if (m_additionalHeaders.length() > 0)
                {
                    //qDebug() << "Has additional headers";
                    for (int i = 0; i < m_additionalHeaders.size(); i++)
                    {
                        RawHeaderPair header = m_additionalHeaders[i];
                        request.setRawHeader(header.first, header.second);
                    }
                }

                QNetworkReply * reply = manager.post(request, "");
                connectSignals(reply);

                emit status(item.path, "Register", "Start registering file", m_uploadUrl.toString());

                uploadHash[reply] = item;
                urlHash[item.path] = reply;
            }
        }
        else if (m_uploadProtocol == UploadInterface::ProtocolMultipart) {

            QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

            item.file = new QFile(item.path);
            item.file->open(QIODevice::ReadOnly);
            item.stage = 0;

            QHttpPart imagePart;
            imagePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                                QVariant("form-data; name=\"document\"; filename=\""+ item.key +"\""));
            imagePart.setBodyDevice(item.file);
            item.file->setParent(multiPart);
            multiPart->append(imagePart);

            QNetworkRequest request(m_uploadUrl);
            request.setRawHeader("User-Agent", m_userAgent);

            QNetworkReply * reply = manager.post(request, multiPart);
            multiPart->setParent(reply);

            item.time.start();
            uploadHash[reply] = item;
            urlHash[item.path] = reply;
        }
        else
        {
            qDebug() << m_uploadProtocol;
            qDebug() << "No one knows";
        }

        startNextUpload();
    }
}

void UploadPlugin::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());

    //qDebug() << "PROGRESS" << reply;

    if(reply->error() == QNetworkReply::NoError)
    {
        UploadItem item = uploadHash[reply];
        qint64 actualSent = item.sent + bytesSent;
        double speed = actualSent * 1000.0 / item.time.elapsed();
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
        int percent = actualSent * 100 / item.size;

        if (item.stage > 0) {
            //qDebug() << "upload" << item.path << actualSent << item.size << percent << speed << unit;
            emit progress(item.path, actualSent, item.size, percent, speed, unit);
        }
    }
}

void UploadPlugin::uploadFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());

    //qDebug() << "FINISHED" << reply;

    if(reply->error() == QNetworkReply::NoError)
    {
        UploadItem item = uploadHash[reply];
        int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        //QByteArray customVerb = reply->request().attribute(QNetworkRequest::CustomVerbAttribute).toByteArray();
        //qDebug() << statusCode << customVerb;

        if (m_uploadProtocol == UploadInterface::ProtocolTus)
        {
            if (item.stage == 0)
            {
                if (item.isResume)
                {
                    QByteArray offset = reply->rawHeader("Offset");

                    //qDebug() << "Get resume offset" << offset;

                    item.stage = 1;
                    item.chunkCounter = 0;
                    item.start = offset.toLongLong();

                    if (reply->hasRawHeader("History-Id"))
                    {
                        QByteArray historyId = reply->rawHeader("History-Id");
                        qDebug() << "Has history id" << historyId;
                        item.historyId = historyId;
                    }

                    uploadHash[reply] = item;
                    uploadChunk(reply);
                }
                else
                {
                    if (statusCode == 201)
                    {
                        QByteArray location = reply->rawHeader("Location");

                        qDebug() << "Get submit url" << location;

                        item.submitUrl = location;
                        item.stage = 1;
                        item.chunkCounter = 0;

                        if (reply->hasRawHeader("History-Id"))
                        {
                            QByteArray historyId = reply->rawHeader("Location");
                            qDebug() << "Has history id" << historyId;
                            item.historyId = historyId;
                        }

                        emit urlSet(item.path, item.submitUrl);

                        uploadHash[reply] = item;
                        uploadChunk(reply);
                    }
                    else
                    {
                        qDebug() << "statusCode" << statusCode;
                        emit status(item.path, "Error", "Failed to create new upload resource", reply->url().toString());
                    }
                }
            }
            else
            {
                //qDebug() << "uploadFinished" << "chunk" << reply;
                qDebug() << "END CHUNK " << item.chunkCounter;
                item.chunkCounter = item.chunkCounter + 1;
                uploadHash[reply] = item;
                uploadChunk(reply);
            }
        }
        else if (m_uploadProtocol == UploadInterface::ProtocolMultipart)
        {
            qDebug() << "What's here?";
        }
        else
        {
            qDebug() << "No one knows";
        }
    }

    reply->deleteLater();
}

void UploadPlugin::uploadError(QNetworkReply::NetworkError)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    UploadItem item = uploadHash[reply];

    //qDebug() << "ERROR" << reply;

    //qDebug() << "uploadError: " << item.submitUrl << reply->errorString();

    emit status(item.path, "Error", reply->errorString(), item.submitUrl);
    emit progress(item.path, 0, 0, 0, 0, "bytes/sec");

    uploadHash.remove(reply);
    urlHash.remove(item.path);

    startNextUpload();
}

void UploadPlugin::uploadSslErrors(QList<QSslError>)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    reply->ignoreSslErrors();
}

void UploadPlugin::setBandwidthLimit(int bytesPerSecond)
{
    m_bandwidthLimit = bytesPerSecond;
    // TODO :: implement rate controller
}
