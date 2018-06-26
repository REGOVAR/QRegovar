#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore>
#include <QtNetwork>

class Settings: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int defaultReference READ defaultReference WRITE setDefaultReference NOTIFY dataChanged)
    Q_PROPERTY(QString pubmedTerms READ pubmedTerms WRITE setPubmedTerms NOTIFY dataChanged)
    Q_PROPERTY(int themeId READ themeId WRITE setThemeId NOTIFY dataChanged)
    Q_PROPERTY(float fontSize READ fontSize WRITE setFontSize NOTIFY dataChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY dataChanged)
    Q_PROPERTY(bool displayHelp READ displayHelp WRITE setDisplayHelp NOTIFY dataChanged)
    Q_PROPERTY(QUrl serverUrl READ serverUrl WRITE setServerUrl NOTIFY dataChanged)
    Q_PROPERTY(QUrl sharedUrl READ sharedUrl WRITE setSharedUrl NOTIFY dataChanged)
    Q_PROPERTY(bool keepMeLogged READ keepMeLogged WRITE setKeepMeLogged NOTIFY dataChanged)
    Q_PROPERTY(QNetworkCookie sessionCookie READ sessionCookie WRITE setSessionCookie NOTIFY dataChanged)
    Q_PROPERTY(int sessionUserId READ sessionUserId WRITE setSessionUserId NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject uploadingFiles READ uploadingFiles NOTIFY dataChanged)

public:
    // Constructors
    Settings(QObject* parent=nullptr);

    // Getters
    inline int defaultReference() const { return mDefaultReference; }
    inline QString pubmedTerms() const { return mPubmedTerms; }
    inline int themeId() const { return mThemeId; }
    inline float fontSize() const { return mFontSize; }
    inline QString language() const { return mLanguage; }
    inline bool displayHelp() const { return mDisplayHelp; }
    inline QUrl serverUrl() const { return mServerUrl; }
    inline QUrl sharedUrl() const { return mSharedUrl; }
    inline bool keepMeLogged() const { return mKeepMeLogged; }
    inline QNetworkCookie sessionCookie() const { return mSessionCookie; }
    inline int sessionUserId() const { return mSessionUserId; }
    QJsonObject uploadingFiles();

    // Setters
    inline void setDefaultReference(int i) { mDefaultReference = i; emit dataChanged(); }
    inline void setPubmedTerms(QString i) { mPubmedTerms = i; emit dataChanged(); }
    inline void setThemeId(int i) { mThemeId = i; emit dataChanged(); }
    inline void setFontSize(float i) { mFontSize = i; emit dataChanged(); }
    inline void setLanguage(QString i) { mLanguage = i; emit dataChanged(); }
    inline void setDisplayHelp(bool i) { mDisplayHelp = i; emit dataChanged(); }
    inline void setServerUrl(QUrl i) { mServerUrl = i; emit dataChanged(); }
    inline void setSharedUrl(QUrl i) { mSharedUrl = i; emit dataChanged(); }
    inline void setKeepMeLogged(bool i) { mKeepMeLogged = i; emit dataChanged(); }
    inline void setSessionCookie(QNetworkCookie cookie) { mSessionCookie = QNetworkCookie(cookie); emit dataChanged(); }
    inline void setSessionUserId(int id) { mSessionUserId = id; emit dataChanged(); }

    // Methods
    Q_INVOKABLE void reload();
    Q_INVOKABLE void save();
    Q_INVOKABLE void addUploadFile(int fileId, QString localPath);
    Q_INVOKABLE void removeUploadFile(int fileId);
    Q_INVOKABLE void clearUploadFile();


Q_SIGNALS:
    void dataChanged();


private:
    int mDefaultReference = 0;
    QString mPubmedTerms;
    int mThemeId;
    float mFontSize = 1;
    QString mLanguage;
    bool mDisplayHelp = true;
    QUrl mServerUrl;
    QUrl mSharedUrl;
    bool mKeepMeLogged = false;
    QNetworkCookie mSessionCookie;
    int mSessionUserId=-1;


    QString serializeJson(QJsonObject json);
    QJsonObject deserializeJson(QString json);
};

#endif // SETTINGS_H
