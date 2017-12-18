#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore>

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
    Q_PROPERTY(QString localCacheDir READ localCacheDir WRITE setLocalCacheDir NOTIFY dataChanged)
    Q_PROPERTY(int localCacheMaxSize READ localCacheMaxSize WRITE setLocalCacheMaxSize NOTIFY dataChanged)

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
    inline QString localCacheDir() const { return mLocalCacheDir; }
    inline int localCacheMaxSize() const { return mLocalCacheMaxSize; }

    // Setters
    inline void setDefaultReference(int i) { mDefaultReference = i; emit dataChanged(); }
    inline void setPubmedTerms(QString i) { mPubmedTerms = i; emit dataChanged(); }
    inline void setThemeId(int i) { mThemeId = i; emit dataChanged(); }
    inline void setFontSize(float i) { mFontSize = i; emit dataChanged(); }
    inline void setLanguage(QString i) { mLanguage = i; emit dataChanged(); }
    inline void setDisplayHelp(bool i) { mDisplayHelp = i; emit dataChanged(); }
    inline void setServerUrl(QUrl i) { mServerUrl = i; emit dataChanged(); }
    inline void setSharedUrl(QUrl i) { mSharedUrl = i; emit dataChanged(); }
    inline void setLocalCacheDir(QString i) { mLocalCacheDir = i; emit dataChanged(); }
    inline void setLocalCacheMaxSize(int i) { mLocalCacheMaxSize = i; emit dataChanged(); }

    // Methods
    Q_INVOKABLE void reload();
    Q_INVOKABLE void save();


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
    QString mLocalCacheDir;
    int mLocalCacheMaxSize = 0;

};

#endif // SETTINGS_H