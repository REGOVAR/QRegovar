#include "restapimanager.h"

RestApiManager::RestApiManager()
{
    // Do nothing that need a call to the Core. Otherwise, shall be done in init() method.
}

void RestApiManager::init()
{
    mNetManager = new QNetworkAccessManager();
    //readSettings();
}






