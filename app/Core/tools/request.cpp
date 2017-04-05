#include "request.h"
#include "core.h"
#include <QDebug>

QNetworkAccessManager* Request::mNetManager = Q_NULLPTR;
QNetworkAccessManager* Request::netManager()
{
    if (mNetManager == Q_NULLPTR)
    {
        mNetManager = new QNetworkAccessManager();
        connect ( mNetManager,
                  SIGNAL(authenticationRequired(QNetworkReply*, QAuthenticator*)),
                  Core::i(),
                  SLOT(authenticationRequired(QNetworkReply*, QAuthenticator*)));
    }

    return mNetManager;
}



Request::Request(Verb verb, const QString& query, const QByteArray& data, QObject* parent) : QObject(parent)
{    
    QNetworkRequest request = Request::makeRequest(query);
    mReply = Q_NULLPTR;
    switch (verb)
    {
        case Request::Get:
            mReply = Request::netManager()->get(request);
            break;
        case Request::Post:
            mReply = Request::netManager()->post(request,data);
            break;
        case Request::Put:
            mReply = Request::netManager()->put(request, data);
            break;
        case Request::Del:
            mReply = Request::netManager()->deleteResource(request);
            break;

        default:
            qDebug() << "ERROR : unknow query verb ... \"" << verb << "\" : \"" << query << "\"";
            break;
    }
    if (mReply != Q_NULLPTR)
    {
        mLoading = true;
        connect(mReply, SIGNAL(finished()), this,SLOT(received()));
    }
}






Request* Request::get(const QString query)
{
    return new Request(Get, query);
}

Request* Request::put(const QString query, const QByteArray &data)
{
    return new Request(Put, query, data);
}

Request* Request::post(const QString query, const QByteArray &data)
{
    return new Request(Post, query, data);
}

Request* Request::del(const QString query)
{
    return new Request(Del, query);
}

QNetworkRequest Request::makeRequest(const QString &resource)
{
    QUrl url(Core::i()->apiRootUrl());
    url.setPath(resource);
    qDebug() << url;

    QNetworkRequest request(url);
    return request;
}




const QJsonDocument &Request::json() const
{
    return mJson;
}

void Request::received()
{
    mLoading = false;
    QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

    if (reply && reply->isFinished())
    {
        if (reply->error() == QNetworkReply::NoError)
        {
            mJson = QJsonDocument::fromJson(reply->readAll());
            emit jsonReceived(mJson);
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "QNetworkReply error : " << reply->error();
        }
    }
    else
    {
        qDebug() << "no answer ?";
    }
}
