#include "settings.h"

Settings::Settings(QObject* parent) : QObject(parent)
{
    reload();
}



void Settings::reload()
{
    // TODO: user dependant
    QSettings settings;

    // Regovar settings
    mDefaultReference = settings.value("defaultRefId", 0).toInt();
    mPubmedTerms = settings.value("pubmedTerms", "").toString();
    // Interface settings
    mThemeId = settings.value("themeId", 0).toInt();
    mFontSize = settings.value("fontSize", 1).toFloat();
    mLanguage = settings.value("language", "EN-En").toString();
    mDisplayHelp = settings.value("displayHelp", false).toBool();
    // Connection settings
    mServerUrl = QUrl(settings.value("serverUrl", "http://dev.regovar.org").toString());
    mSharedUrl = QUrl(settings.value("sharedUrl", "http://shared.regovar.org").toString());
    // Local cache settings
    mLocalCacheDir = settings.value("cacheDir", "").toString();
    mLocalCacheMaxSize = settings.value("cacheMaxSize", 100).toInt();
    // Cookie
    mKeepMeLogged = settings.value("keepMeLogged", false).toBool();
    mSessionUserId = settings.value("sessionUserId", -1).toUInt();
    if (mSessionUserId > 0)
    {
        QByteArray name = settings.value("sessionCookieName", "trash").toByteArray();
        QByteArray value = settings.value("sessionCookieValue", "trash").toByteArray();
        mSessionCookie = QNetworkCookie(name, value);
        qDebug() << "RETRIEVE SESSION: " << QString(name) << "=" << QString(value);
    }

    emit dataChanged();
}


void Settings::save()
{
    QSettings settings;

    // Regovar settings
    settings.setValue("defaultRefId", mDefaultReference);
    settings.setValue("pubmedTerms", mPubmedTerms);
    // Interface settings
    settings.setValue("themeId", mThemeId);
    settings.setValue("fontSize", mFontSize);
    settings.setValue("language", mLanguage);
    settings.setValue("displayHelp", mDisplayHelp);
    // Connection settings
    settings.setValue("serverUrl", mServerUrl.toString());
    settings.setValue("sharedUrl",mSharedUrl.toString());
    // Loca cache settings
    settings.setValue("cacheDir", mLocalCacheDir);
    settings.setValue("cacheMaxSize", mLocalCacheMaxSize);
    // Cookie
    settings.setValue("keepMeLogged", mKeepMeLogged);
    if (mKeepMeLogged && mSessionUserId > 0)
    {
        settings.setValue("sessionUserId", mSessionUserId);
        settings.setValue("sessionCookieName", mSessionCookie.name());
        settings.setValue("sessionCookieValue", mSessionCookie.value());
    }
    else
    {
        settings.setValue("sessionUserId", -1);
        settings.setValue("sessionCookieName", QByteArray());
        settings.setValue("sessionCookieValue", QByteArray());
    }
}



