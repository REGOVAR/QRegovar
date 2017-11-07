#ifndef REQUESTEXT_H
#define REQUESTEXT_H



#include <QObject>
#include <QtNetwork>
#include <QJsonObject>
#include <QJsonDocument>



class RequestExt : public QObject
{
    Q_OBJECT
public:
    enum Verb { Get, Post, Put, Del, Patch, Head};
    Q_ENUM(Verb)
    RequestExt(Verb verb, const QString& query, QHttpMultiPart* data=nullptr, QObject* parent=0);
    RequestExt(Verb verb, const QString& query, const QByteArray& data, QObject* parent=0);
    static QNetworkAccessManager* netManager();
    // Factories
    static RequestExt* get_url(const QString& query) ;
    static RequestExt* get(const QString& query) ;
    static RequestExt* post(const QString& query, QHttpMultiPart* data=nullptr);
    static RequestExt* post(const QString& query, const QByteArray& data);
    static RequestExt* put(const QString& query,  QHttpMultiPart* data=nullptr);
    static RequestExt* put(const QString& query,  const QByteArray& data);
    static RequestExt* del(const QString& query);
    // static Request* patch(const QString query,const QByteArray& data = QByteArray());
    // static Request* head(const QString query);
    static QNetworkRequest makeRequest(const QString& resource) ;


    // Accessors
    const QJsonObject& json() const;
    inline bool success() { return mSuccess; }
    inline bool loading() { return mLoading; }
    inline QNetworkReply::NetworkError replyError() { return mReplyError; }


Q_SIGNALS :
    void responseReceived(const QJsonObject& json);

protected Q_SLOTS:
    void received();

private:
    static QNetworkAccessManager* mNetManager;

    bool mLoading = false;
    bool mSuccess = false;
    QNetworkReply::NetworkError mReplyError;
    QNetworkReply* mReply = nullptr;
    QJsonObject mJson;
};

#endif // REQUESTEXT_H
