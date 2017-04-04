#ifndef REQUEST_H
#define REQUEST_H
#include <QObject>
#include <QtNetwork>
#include <QJsonObject>
#include <QJsonDocument>


enum RequestVerb { GET, POST, PUT, DEL, PATCH, HEAD };

class Request : public QObject
{
    Q_OBJECT
public:
    Request(const RequestVerb verb, const QString query, const QByteArray& data=QByteArray(), QObject* parent=0);

    // Factories
    static Request* get(const QString query);
    static Request* post(const QString query,const QByteArray& data=QByteArray());
    static Request* put(const QString query, const QByteArray& data=QByteArray());
    static Request* del(const QString query);
    // static Request* patch(const QString query,const QByteArray& data = QByteArray());
    // static Request* head(const QString query);
    static QNetworkRequest makeRequest(const QString& resource) ;


    const QJsonDocument& json() const;
    inline bool loading() { return mLoading; }

signals :
    void jsonReceived(const QJsonDocument& json);


protected Q_SLOTS:
    void received();

private:
    bool mLoading = false;
    QNetworkReply* mReply;
    QJsonDocument mJson;

    static QList<QNetworkReply> mRequestQueue;
};

#endif // REQUEST_H
