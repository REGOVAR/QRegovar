#include "requestext.h"
#include "Model/regovar.h"
#include <QDebug>

QNetworkAccessManager* RequestExt::mNetManager = nullptr;
QNetworkAccessManager* RequestExt::netManager()
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
RequestExt::RequestExt(Verb verb, const QString& query, QHttpMultiPart* data, QObject* parent) : QObject(parent)
{

    QNetworkRequest request = RequestExt::makeRequest(query);
    if (query.startsWith("https://"))
    {
        request.setSslConfiguration(QSslConfiguration::defaultConfiguration());
    }
    mReply = nullptr;
    switch (verb)
    {
        case RequestExt::Get:
            mReply = RequestExt::netManager()->get(request);
            break;
        case RequestExt::Post:
            mReply = RequestExt::netManager()->post(request, data);
            break;
        case RequestExt::Put:
            mReply = RequestExt::netManager()->put(request, data);
            break;
        case RequestExt::Del:
            mReply = RequestExt::netManager()->deleteResource(request);
            break;

        default:
            qCritical() << Q_FUNC_INFO << "Unknow query verb ... \"" << verb << "\" : \"" << query << "\"";
            break;
    }
    if (mReply != nullptr)
    {
        mLoading = true;
        connect(mReply, SIGNAL(finished()), this, SLOT(received()));
    }
}
//------------------------------------------------------------------------------------------------
RequestExt::RequestExt(Verb verb, const QString& query, const QByteArray& data, QObject* parent) : QObject(parent)
{
    QNetworkRequest request = RequestExt::makeRequest(query);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    if (query.startsWith("https://"))
    {
        request.setSslConfiguration(QSslConfiguration::defaultConfiguration());
    }

    mReply = Q_NULLPTR;
    switch (verb)
    {
        case RequestExt::Get:
            mReply = RequestExt::netManager()->get(request);
            break;
        case RequestExt::Post:
            mReply = RequestExt::netManager()->post(request, data);
            break;
        case RequestExt::Put:
            mReply = RequestExt::netManager()->put(request, data);
            break;
        case RequestExt::Del:
            mReply = RequestExt::netManager()->deleteResource(request);
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
RequestExt* RequestExt::get(const QString& query)
{
    return new RequestExt(Get, query);
}
//------------------------------------------------------------------------------------------------
RequestExt* RequestExt::put(const QString& query, QHttpMultiPart* data)
{
    return new RequestExt(Put, query, data);
}
//------------------------------------------------------------------------------------------------
RequestExt* RequestExt::put(const QString& query, const QByteArray& data)
{
    return new RequestExt(Put, query, data);
}
//------------------------------------------------------------------------------------------------
RequestExt* RequestExt::post(const QString& query, QHttpMultiPart* data)
{
    return new RequestExt(Post, query, data);
}
//------------------------------------------------------------------------------------------------
RequestExt* RequestExt::post(const QString& query, const QByteArray& data)
{
    return new RequestExt(Post, query, data);
}
//------------------------------------------------------------------------------------------------
RequestExt* RequestExt::del(const QString& query)
{
    return new RequestExt(Del, query);
}
//------------------------------------------------------------------------------------------------
QNetworkRequest RequestExt::makeRequest(const QString& resource)
{
    QUrl url(resource);
    qDebug() << "REQUEST:" << url.toString();

    QNetworkRequest request(url);
    return request;
}
//------------------------------------------------------------------------------------------------
const QJsonObject &RequestExt::json() const
{
    return mJson;
}
//------------------------------------------------------------------------------------------------
void RequestExt::received()
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
            emit responseReceived(mJson);
        }
        else
        {
            QString code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString();
            QString reason = reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
            mJson.insert("reqError", code + " " + reason);
            qWarning() << "ERROR" << code << reason << mReplyError;
            emit responseReceived(mJson);
        }
    }
    else
    {
        qCritical() << "CRITICAL ERROR"<< Q_FUNC_INFO << "Request ends with no answer ? How it's possible";
    }
}
//------------------------------------------------------------------------------------------------
