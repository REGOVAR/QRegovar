#ifndef PIPELINE_H
#define PIPELINE_H

#include <QtCore>
#include "Model/framework/dynamicformmodel.h"

class DynamicFormModel;

class Pipeline : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(bool starred READ starred WRITE setStarred NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString version READ version NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QDateTime installationDate READ installationDate NOTIFY dataChanged)
    Q_PROPERTY(QString versionApi READ versionApi NOTIFY dataChanged)
    // Related documents
    Q_PROPERTY(QUrl icon READ icon NOTIFY neverChanged)
    Q_PROPERTY(QUrl form READ form NOTIFY neverChanged)
    Q_PROPERTY(QUrl homePage READ homePage NOTIFY neverChanged)
    Q_PROPERTY(QUrl helpPage READ helpPage NOTIFY neverChanged)
    Q_PROPERTY(QUrl license READ license NOTIFY neverChanged)
    Q_PROPERTY(QUrl readme READ readme NOTIFY neverChanged)
    Q_PROPERTY(QUrl manifest READ manifest NOTIFY neverChanged)


    Q_PROPERTY(DynamicFormModel* configForm READ configForm NOTIFY neverChanged)



public:
    // Constructor
    explicit Pipeline(QObject* parent=nullptr);
    explicit Pipeline(int id, QObject* parent=nullptr);
    explicit Pipeline(QJsonObject json);

    // Getters
    inline int id() const { return mId; }
    inline bool starred() const { return mStarred; }
    inline QString name() const { return mName; }
    inline QString type() const { return mType; }
    inline QString status() const { return mStatus; }
    inline QString description() const { return mDescription; }
    inline QDateTime installationDate() const { return mInstallationDate; }
    inline QString version() const { return mVersion; }
    inline QString versionApi() const { return mVersionApi; }
    inline QUrl icon() const { return mIcon; }
    inline QUrl form() const { return mForm; }
    inline QUrl helpPage() const { return mHelpPage; }
    inline QUrl homePage() const { return mHomePage; }
    inline QUrl license() const { return mLicense; }
    inline QUrl readme() const { return mReadme; }
    inline QUrl manifest() const { return mManifest; }
    inline QString searchField() const { return mSearchField; }
    inline DynamicFormModel* configForm() const { return mConfigForm; }

    Q_INVOKABLE inline QJsonObject manifestJson() const { return mManifestJson; }
    Q_INVOKABLE inline QJsonObject formJson() const { return mFormJson; }

    // Setters
    Q_INVOKABLE inline void setStarred(bool flag) { mStarred = flag; emit dataChanged();}

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Ask the server to install this pipeline
    Q_INVOKABLE void install();
    //! Load pipeline information from server
    Q_INVOKABLE void load(bool forceRefresh=true);


Q_SIGNALS:
    void neverChanged();
    void dataChanged();

public Q_SLOTS:
    void updateSearchField();

private:
    bool mLoaded = false;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    int mId=-1;
    bool mStarred = false;
    QString mName;
    QString mType;
    QString mStatus;
    QString mDescription;
    QDateTime mInstallationDate;
    QString mVersion;
    QString mVersionApi;

    QUrl mIcon;
    QUrl mForm;
    QUrl mHelpPage;
    QUrl mHomePage;
    QUrl mLicense;
    QUrl mReadme;
    QUrl mManifest;
    QString mSearchField;

    QJsonObject mManifestJson;
    QJsonObject mFormJson;

    //! The form model to configure the pipeline
    DynamicFormModel* mConfigForm = nullptr;

    static QHash<QString, QString> mTypeIconMap;
    static QHash<QString, QString> initTypeIconMap();
};

#endif // PIPELINE_H
