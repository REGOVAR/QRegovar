#include "request.h"
#include "Model/regovar.h"
#include <QDebug>

QNetworkAccessManager* Request::mNetManager = nullptr;
QNetworkAccessManager* Request::netManager()
{
    if (mNetManager == Q_NULLPTR)
    {
        mNetManager = new QNetworkAccessManager();
        connect ( mNetManager,
                  SIGNAL(authenticationRequired(QNetworkReply*, QAuthenticator*)),
                  Regovar::i(),
                  SLOT(onAuthenticationRequired(QNetworkReply*, QAuthenticator*)));
    }

    return mNetManager;
}
//------------------------------------------------------------------------------------------------
Request::Request(Verb verb, const QString& query, QHttpMultiPart* data, QObject* parent) : QObject(parent)
{

    QNetworkRequest request = Request::makeRequest(query);
    mReply = nullptr;
    switch (verb)
    {
        case Request::Get:
            mReply = Request::netManager()->get(request);
            break;
        case Request::Post:
            mReply = Request::netManager()->post(request, data);
            break;
        case Request::Put:
            mReply = Request::netManager()->put(request, data);
            break;
        case Request::Del:
            mReply = Request::netManager()->deleteResource(request);
            break;

        default:
            qCritical() << Q_FUNC_INFO << "Unknow query verb ... \"" << verb << "\" : \"" << query << "\"";
            break;
    }
    if (mReply != nullptr)
    {
        mLoading = true;
        connect(mReply, SIGNAL(finished()), this,SLOT(received()));
    }
}
//------------------------------------------------------------------------------------------------
Request::Request(Verb verb, const QString& query, const QByteArray& data, QObject* parent) : QObject(parent)
{
    QNetworkRequest request = Request::makeRequest(query);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    mReply = Q_NULLPTR;
    switch (verb)
    {
        case Request::Get:
            mReply = Request::netManager()->get(request);
            break;
        case Request::Post:
            mReply = Request::netManager()->post(request, data);
            break;
        case Request::Put:
            mReply = Request::netManager()->put(request, data);
            break;
        case Request::Del:
            mReply = Request::netManager()->deleteResource(request);
            break;

        default:
            qCritical() << Q_FUNC_INFO << "Unknow query verb ... \"" << verb << "\" : \"" << query << "\"";
            break;
    }
    if (mReply != nullptr)
    {
        mLoading = true;
        connect(mReply, SIGNAL(finished()), this,SLOT(received()));
    }
}
//------------------------------------------------------------------------------------------------
Request* Request::get(const QString& query)
{
    return new Request(Get, query);
}
//------------------------------------------------------------------------------------------------
Request* Request::put(const QString& query, QHttpMultiPart* data)
{
    return new Request(Put, query, data);
}
//------------------------------------------------------------------------------------------------
Request* Request::put(const QString& query, const QByteArray& data)
{
    return new Request(Put, query, data);
}
//------------------------------------------------------------------------------------------------
Request* Request::post(const QString& query, QHttpMultiPart* data)
{
    return new Request(Post, query, data);
}
//------------------------------------------------------------------------------------------------
Request* Request::post(const QString& query, const QByteArray& data)
{
    return new Request(Post, query, data);
}
//------------------------------------------------------------------------------------------------
Request* Request::del(const QString& query)
{
    return new Request(Del, query);
}
//------------------------------------------------------------------------------------------------
QNetworkRequest Request::makeRequest(const QString& resource)
{
    QUrl url(Regovar::i()->serverUrl());
    url.setPath(resource);
    qDebug() << "REQUEST:" << url.toString();

    QNetworkRequest request(url);
    return request;
}
//------------------------------------------------------------------------------------------------
const QJsonObject &Request::json() const
{
    return mJson;
}
//------------------------------------------------------------------------------------------------
void Request::received()
{
    mLoading = false;
    QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

    if (reply && reply->isFinished())
    {
        mReplyError = reply->error();
        if (mReplyError == QNetworkReply::NoError)
        {
            regovar->setConnectionStatus(Regovar::ServerStatus::ready);
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            mJson = doc.object();
            mSuccess = mJson["success"].toBool();
            mJson.insert("query", reply->url().toString());
            mJson.insert("reqError", "200 OK");
            emit responseReceived(mSuccess, mJson);
        }
        else
        {
            QString code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString();
            QString reason = reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
            mJson = QJsonObject();
            mJson.insert("reqError", code + " " + reason);
            mJson.insert("query", reply->url().toString());
            qWarning() << "ERROR" << code << reason << mReplyError;
            if (code == "502")
            {
                regovar->setConnectionStatus(Regovar::ServerStatus::unreachable);
                mJson.insert("code", "E000000");
                mJson.insert("msg",  tr("Server unreachable. Check your settings and ensure that the server is ON."));
            }
            else if (code == "403")
            {
                regovar->setConnectionStatus(Regovar::ServerStatus::accessDenied);
                mJson.insert("code", "E000001");
                mJson.insert("msg",  tr("Authentication required. Please log in."));
            }
            else
            {
                regovar->setConnectionStatus(Regovar::ServerStatus::error);
                mJson.insert("code", "E000002");
                mJson.insert("msg",  tr("An unexpected error occured server side. More informations available on server logs."));
            }
            mSuccess = false;
            emit responseReceived(mSuccess, mJson);
        }
    }
    else
    {
        qCritical() << "CRITICAL ERROR"<< Q_FUNC_INFO << "Request ends with no answer ? How it's possible";
    }
}
//------------------------------------------------------------------------------------------------
