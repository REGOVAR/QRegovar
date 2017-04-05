#include "request.h"
#include "core.h"
#include <QDebug>


Request::Request(Verb verb, const QString& query, const QByteArray& data, QObject* parent) : QObject(parent)
{
    QNetworkRequest request = Request::makeRequest(query);
    mReply = Q_NULLPTR;
    switch (verb)
    {
        case Request::Get:
            mReply = Core::i()->api()->netManager()->get(request);
            break;
        case Request::Post:
            mReply = Core::i()->api()->netManager()->post(request,data);
            break;
        case Request::Put:
            mReply = Core::i()->api()->netManager()->put(request, data);
            break;
        case Request::Del:
            mReply = Core::i()->api()->netManager()->deleteResource(request);
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
    QUrl url;
    url.setScheme(Core::i()->api()->scheme());
    url.setHost(Core::i()->api()->host());
    url.setPath(Core::i()->api()->prefix() + resource);
    url.setPort(Core::i()->api()->port());

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

    if (reply)
    {
       mJson = QJsonDocument::fromJson(reply->readAll());
       emit jsonReceived(mJson);
    }
}
