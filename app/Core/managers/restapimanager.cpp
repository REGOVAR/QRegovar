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
    Core::i()->settings()->beginGroup("RemoteServer");
    Core::i()->settings()->setValue("scheme", mScheme);
    Core::i()->settings()->setValue("host", mHost);
    Core::i()->settings()->setValue("prefix", mPrefix);
    Core::i()->settings()->setValue("port", mPort);
    Core::i()->settings()->endGroup();
}

void RestApiManager::readSettings()
{
    // TODO : No hardcoded value => Load default from local config file ?
    Core::i()->settings()->beginGroup("RemoteServer");
    mScheme = Core::i()->settings()->value("scheme", "https").toString();
    mHost = Core::i()->settings()->value("host", "annso.absolumentg.fr").toString();
    mPrefix = Core::i()->settings()->value("prefix", "").toString();
    mPort = Core::i()->settings()->value("port", 443).toInt();
    Core::i()->settings()->endGroup();
}
