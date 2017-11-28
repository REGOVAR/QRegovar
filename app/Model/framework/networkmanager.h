#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QtWebSockets/QtWebSockets>

#include "networktask.h"



class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(QUrl sharedServerUrl READ sharedServerUrl WRITE setSharedServerUrl NOTIFY sharedServerUrlChanged)
    Q_PROPERTY(ServerStatus status READ status WRITE setStatus NOTIFY statusChanged)


public:
    enum ServerStatus
    {
        // Connected to the sever.
        ready=0,
        // Connection refused : user need to login
        accessDenied,
        // Server is in error : returned HTTP 500
        error,
        // Not eable to reach the server : are url/proxy settings good ? Is the server on ?
        unreachable
    };
    Q_ENUMS(ServerStatus)

    // Constructors
    explicit NetworkManager(QObject* parent=nullptr);


    // Getters
    inline QUrl& serverUrl() { return mServerUrl; }
    inline QUrl& sharedServerUrl() { return mSharedServerUrl; }
    inline ServerStatus status() { return mStatus; }

    // Setters
    inline void setStatus(ServerStatus flag) { mStatus = flag; emit statusChanged(); }
    void setServerUrl(QUrl url);
    void setSharedServerUrl(QUrl url);

    // Methods
    Q_INVOKABLE bool testServerUrl(QString url);


public Q_SLOTS:
    void onAuthenticationRequired(QNetworkReply* request, QAuthenticator* authenticator);

    // Websocket
    void onWebsocketConnected();
    void onWebsocketClosed();
    void onWebsocketError(QAbstractSocket::SocketError error);
    void onWebsocketStateChanged(QAbstractSocket::SocketState state);
    void onWebsocketReceived(QString message);


Q_SIGNALS:
    void serverUrlChanged();
    void sharedServerUrlChanged();
    void statusChanged();
    void testServerUrlDone(bool success, QString url);
    void websocketMessageReceived(QString action, QJsonObject data);


private:
    //! The root url to the server api
    QUrl mServerUrl;
    QUrl mSharedServerUrl;

    //! List of all network task currently in progress
    QList<NetworkTask*> mTasks;
    //! Server connection status
    ServerStatus mStatus;
    //! Websocket
    QWebSocket mWebSocket;
    QUrl mWebsocketUrl;


    // Internals list of push notification key, to know which manager handle them
    QStringList mWsFilesActionsList = {"file_upload"};
    QStringList mWsSamplesActionsList = {"import_vcf_processing"};
    QStringList mWsFilteringActionsList = {"analysis_computing"};
    QStringList mWsPipelinesActionsList = {"pipeline_install", "pipeline_uninstall"};
    QStringList mWsJobsActionsList = {"job_"};
};

#endif // NETWORKMANAGER_H
