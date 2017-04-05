#ifndef RESTAPIMANAGER_H
#define RESTAPIMANAGER_H

#include <QObject>
#include <QtCore>
#include <QNetworkAccessManager>
#include "core.h"




class RestApiManager : public QObject
{
    Q_OBJECT


public:
    RestApiManager();
    void init();


    // Read accessors
    inline QNetworkAccessManager* netManager() const { return mNetManager; }
    inline const QString& host() const { return mHost; }
    inline const QString& prefix() const { return mPrefix; }
    inline const QString& scheme() const { return mScheme; }
    inline int port() const { return mPort; }


private:
    QString mHost;
    QString mPrefix;
    QString mScheme;
    int mPort;

    QNetworkAccessManager * mNetManager;
};

#endif // RESTAPIMANAGER_H
