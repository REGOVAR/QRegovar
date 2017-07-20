#include "tusuploader.h"

#include <QFileInfo>
#include <QTimer>
#include <QBuffer>




TusUploader::TusUploader(QObject *parent) : QObject(parent)
{
    mChunkSize = 50 * 1024;
    mBandWidthLimit = 0; // Not implemented
    mMaxUpload = 2;
    mTusVersion = "1.0.0";
    mUserAgent = "RegovarClient/1.0";

    loadSettings();
}

TusUploader::~TusUploader()
{
    writteSettings();
}



void TusUploader::loadSettings()
{

}

void TusUploader::writteSettings()
{

}






QString TusUploader::prepare(QString path)
{
    QFileInfo fi(path);
    if (fi.isFile())
    {
        qDebug() << "upload append" << path;

        TusUploadItem* item = new TusUploadItem();
        item->path = path;
        item->offset = 0;
        item->file = nullptr;
        item->uploadUrl = "";
        item->file = new QFile(item->path);
        item->file->open(QIODevice::ReadOnly);
        item->size = item->file->size();
        item->prepareFlag = true; // register the file (don't start upload after this call)

        newUpload(item);


        // Then enqueue file
        mQueue.enqueue(item);
        if (mQueue.count() == 1)
        {
            startNext();
        }
    }
}


void TusUploader::enqueue(QString path)
{
    QFileInfo fi(path);
    if (fi.isFile())
    {
        qDebug() << "upload append" << path;

        TusUploadItem* item = new TusUploadItem();
        item->path = path;
        item->offset = 0;
        item->file = nullptr;
        item->uploadUrl = "";
        item->prepareFlag = false;
        mQueue.enqueue(item);

        if (mQueue.count() == 1)
        {
            startNext();
        }
    }
}

void TusUploader::pause(QString path)
{

}

void TusUploader::cancel(QString path)
{

}

void TusUploader::start(QString path)
{

}





void TusUploader::startNext()
{
    // if nothing to do
    if (mQueue.isEmpty())
    {
        return;
    }

    // start new upload if limit not reached
    if (mInProgress.count() < mMaxUpload)
    {
        TusUploadItem* item = mQueue.dequeue();
        mInProgress.append(item);

        // If we don't already have the upload url, new to ask server to create new one for this file
        if (item->uploadUrl.isEmpty())
        {
            // Retrieve file data
            item->file = new QFile(item->path);
            item->file->open(QIODevice::ReadOnly);
            item->size = item->file->size();


            newUpload(item);
        }
        // If we already have the upload url, ask server to provide resume offset
        else
        {
            resumeUpload(item);
        }

        // Continue to depile queue as long as possible
        startNext();
    }
}





void TusUploader::newUpload(TusUploadItem* item)
{
    QByteArray size;
    size.setNum(item->size);
    QString filename("filename " + base64Encode(item->file->fileName()));

    QNetworkRequest request(mTusUploadUrl);
    request.setRawHeader("User-Agent", mUserAgent);
    request.setRawHeader("Tus-Resumable", mTusVersion);
    request.setRawHeader("Content-Length", 0);
    request.setRawHeader("Upload-Length", size);
    request.setRawHeader("Upload-Metadata", filename.toUtf8());

    QNetworkReply * reply = mNetManager.post(request, QByteArray());
    mRequestHash.insert(reply, item);
    connectErrorSignals(reply);
    connect(reply, SIGNAL(finished()), this, SLOT(newUploadFinished()));

    qDebug() << "NEW Upload" << item->file->fileName() << " : POST " << mTusUploadUrl;
}

void TusUploader::resumeUpload(TusUploadItem* item)
{
    QNetworkRequest request(item->uploadUrl);
    request.setRawHeader("User-Agent", mUserAgent);
    request.setRawHeader("Tus-Resumable", mTusVersion);

    QNetworkReply * reply = mNetManager.head(request);
    mRequestHash.insert(reply, item);
    connectErrorSignals(reply);
    connect(reply, SIGNAL(finished()), this, SLOT(resumeUploadFinished()));

    qDebug() << "RESUME Upload" << item->file->fileName() << " : HEAD " << item->uploadUrl;
}

void TusUploader::patchUpload(TusUploadItem* item)
{
    if (item->offset < item->size)
    {
        // Get next chunk
        quint64 start = item->offset;
        quint64 end = start + mChunkSize;
        if (end > item->size)
        {
            end = item->size;
        }
        qint64 chunkSize = end - start;

        QByteArray size;
        size.setNum(item->size);

        QByteArray offset;
        offset.setNum(start);

        QByteArray length;
        length.setNum(chunkSize);

        uchar *buf = item->file->map(start, chunkSize);
        QBuffer * chunkBuffer = new QBuffer();
        chunkBuffer->setData(reinterpret_cast<const char*>(buf), chunkSize);
        chunkBuffer->close();

        QNetworkRequest request(item->uploadUrl);
        request.setRawHeader("User-Agent", mUserAgent);
        request.setRawHeader("Tus-Resumable", mTusVersion);
        request.setRawHeader("Connection", "keep-alive");
        request.setRawHeader("Cache-Control", "no-cache");
        request.setRawHeader("Pragma", "no-cache");
        request.setRawHeader("Content-Type", "application/offset+octet-stream");
        request.setRawHeader("Content-Length", size);
        request.setRawHeader("Upload-Offset", offset);

        QNetworkReply * reply = mNetManager.sendCustomRequest(request, "PATCH", chunkBuffer);
        mRequestHash.insert(reply, item);
        connectErrorSignals(reply);
        connect(reply, SIGNAL(finished()), this, SLOT(patchUploadFinished()));

        item->file->unmap(buf);
        item->offset += chunkSize;

        qDebug() << "PATCH Upload" << item->file->fileName() << " : PATCH " << item->uploadUrl;
    }
    else
    {
        qDebug() << "UPLOAD DONE. " << item->path << "to" << item->uploadUrl;
        item->file->close();
        item->file->deleteLater();


        mInProgress.removeOne(item);
        emit uploadEnded(item);
        startNext();
    }
}







void TusUploader::newUploadFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if(reply->error() == QNetworkReply::NoError)
    {
        TusUploadItem* item = mRequestHash[reply];
        int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (statusCode == 201)
        {
            item->uploadUrl = mTusRootUrl + "/" + QString(reply->rawHeader("Location"));
            item->offset = 0;
            mRequestHash.remove(reply);

            if (!item->prepareFlag)
            {
                emit uploadStarted(item);
                patchUpload(item);
            }
        }
        else
        {
            qDebug() << "newUploadFinished returned wrong status code : " << statusCode << ". Failed to create new upload resource";
        }
    }
    reply->deleteLater();
}

void TusUploader::resumeUploadFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if(reply->error() == QNetworkReply::NoError)
    {
        TusUploadItem* item = mRequestHash[reply];
        QByteArray offset = reply->rawHeader("Upload-Offset");
        item->offset = offset.toInt();

        mRequestHash.remove(reply);
        emit uploadStarted(item);
        patchUpload(item);
    }
    reply->deleteLater();
}

void TusUploader::patchUploadFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if(reply->error() == QNetworkReply::NoError)
    {
        TusUploadItem* item = mRequestHash[reply];
        QByteArray offset = reply->rawHeader("Upload-Offset");
        item->offset = offset.toInt();

        mRequestHash.remove(reply);
        patchUpload(item);
    }
    reply->deleteLater();
}













void TusUploader::connectErrorSignals(QNetworkReply *reply)
{
    // TODO manage error
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(uploadError(QNetworkReply::NetworkError)));
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)),        this, SLOT(uploadSslErrors(QList<QSslError>)));
}

QString TusUploader::base64Encode(QString string)
{
    QByteArray ba;
    ba.append(string);
    return ba.toBase64();
}



void TusUploader::uploadError(QNetworkReply::NetworkError)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    TusUploadItem* item = mRequestHash[reply];

    qDebug() << "ERROR" << reply;

    qDebug() << "uploadError: " << reply->errorString();




    startNext();
}

void TusUploader::uploadSslErrors(QList<QSslError>)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    reply->ignoreSslErrors();
}

