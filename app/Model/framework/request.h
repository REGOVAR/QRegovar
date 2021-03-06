#ifndef REQUEST_H
#define REQUEST_H
#include <QObject>
#include <QtNetwork>
#include <QJsonObject>
#include <QJsonDocument>



class Request : public QObject
{
    Q_OBJECT
public:
    enum Verb { Get, Post, Put, Del, Patch, Head, Download};
    Q_ENUM(Verb)
    Request(Verb verb, const QString& query, QHttpMultiPart* data=nullptr, QObject* parent=0);
    Request(Verb verb, const QString& query, const QByteArray& data, QObject* parent=0);
    static QNetworkAccessManager* netManager();
    // Factories
    static Request* get_url(const QString& query) ;
    static Request* get(const QString& query) ;
    static Request* post(const QString& query, QHttpMultiPart* data=nullptr);
    static Request* post(const QString& query, const QByteArray& data);
    static Request* put(const QString& query,  QHttpMultiPart* data=nullptr);
    static Request* put(const QString& query,  const QByteArray& data);
    static Request* del(const QString& query);
    static Request* download(const QString& query);
    // static Request* patch(const QString query,const QByteArray& data = QByteArray());
    // static Request* head(const QString query);
    static void setCookie(const QNetworkCookie& cookie);
    static QNetworkRequest makeRequest(const QString& resource) ;


    // Accessors
    const QJsonObject& json() const;
    inline bool success() { return mSuccess; }
    inline bool loading() { return mLoading; }
    inline QNetworkReply::NetworkError replyError() { return mReplyError; }


Q_SIGNALS :
    void responseReceived(bool success, const QJsonObject& json);
    void downloadReceived(bool success, const QByteArray& data);

protected Q_SLOTS:
    void received();

private:
    static QNetworkAccessManager* mNetManager;

    bool mLoading = false;
    bool mSuccess = false;
    QNetworkReply::NetworkError mReplyError;
    QNetworkReply* mReply = nullptr;
    QJsonObject mJson;
    bool mJsonQuery;
};

#endif // REQUEST_H
