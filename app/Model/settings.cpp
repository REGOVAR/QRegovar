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
    mServerUrl = QUrl(settings.value("serverUrl", "http://test.regovar.org").toString());
    mSharedUrl = QUrl(settings.value("sharedUrl", "http://shared.regovar.org").toString());
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



void Settings::addUploadFile(int fileId, QString localPath)
{
    QSettings settings;
    QJsonObject data = deserializeJson(settings.value("uploadingFiles").toString());
    if (!data.contains(QString::number(fileId)))
    {
        data.insert(QString::number(fileId), localPath);
        settings.setValue("uploadingFiles", serializeJson(data));
        emit dataChanged();
    }
}



void Settings::removeUploadFile(int fileId)
{
    QSettings settings;
    QJsonObject data = deserializeJson(settings.value("uploadingFiles").toString());
    if (data.contains(QString::number(fileId)))
    {
        data.remove(QString::number(fileId));
        settings.setValue("uploadingFiles", serializeJson(data));
        emit dataChanged();
    }
}



void Settings::clearUploadFile()
{
    QSettings settings;
    settings.setValue("uploadingFiles", "");
}




QString Settings::serializeJson(QJsonObject json)
{
    QJsonDocument doc(json);
    QString data(doc.toJson(QJsonDocument::Compact));
    return data;
}
QJsonObject Settings::deserializeJson(QString data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    if(!doc.isNull())
    {
        if(doc.isObject())
        {
            return doc.object();
        }
    }
    return QJsonObject();
}


QJsonObject Settings::uploadingFiles()
{
    QSettings settings;
    return deserializeJson(settings.value("uploadingFiles").toString());
}
