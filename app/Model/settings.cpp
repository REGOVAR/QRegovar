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
    mDisplayHelp = settings.value("displayHelp", 0).toBool();
    // Connection settings
    mServerUrl = QUrl(settings.value("serverUrl", "http://dev.regovar.org").toString());
    mSharedUrl = QUrl(settings.value("sharedUrl", "http://shared.regovar.org").toString());
    // Loca cache settings
    mLocalCacheDir = settings.value("cacheDir", "").toString();
    mLocalCacheMaxSize = settings.value("cacheMaxSize", 100).toInt();

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

}



