#include "restapimanager.h"

RestApiManager::RestApiManager()
{
    // Do nothing that need a call to the Core. Otherwise, shall be done in init() method.
}

void RestApiManager::init()
{
    mNetManager = new QNetworkAccessManager();
    readSettings();
}





void RestApiManager::writeSettings()
{
    QSettings settings;
    settings.beginGroup("RemoteServer");
    settings.setValue("scheme", mScheme);
    settings.setValue("host", mHost);
    settings.setValue("prefix", mPrefix);
    settings.setValue("port", mPort);
    settings.endGroup();
}

void RestApiManager::readSettings()
{
    // TODO : No hardcoded value => Load default from local config file ?
    QSettings settings;
    settings.beginGroup("RemoteServer");
    mScheme = settings.value("scheme", "https").toString();
    mHost = settings.value("host", "annso.absolumentg.fr").toString();
    mPrefix = settings.value("prefix", "").toString();
    mPort = settings.value("port", 443).toInt();
    settings.endGroup();
}
