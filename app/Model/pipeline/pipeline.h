#ifndef PIPELINE_H
#define PIPELINE_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/framework/dynamicformmodel.h"

class DynamicFormModel;

class Pipeline : public RegovarResource
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
    // Related documents
    Q_PROPERTY(QString icon READ icon NOTIFY neverChanged)
    Q_PROPERTY(QString form READ form NOTIFY neverChanged)
    Q_PROPERTY(QString aboutPage READ aboutPage NOTIFY neverChanged)
    Q_PROPERTY(QString helpPage READ helpPage NOTIFY neverChanged)
    Q_PROPERTY(QString license READ license NOTIFY neverChanged)
    Q_PROPERTY(QString readme READ readme NOTIFY neverChanged)
    Q_PROPERTY(QString manifest READ manifest NOTIFY neverChanged)


    Q_PROPERTY(DynamicFormModel* configForm READ configForm NOTIFY neverChanged)



public:
    // Constructor
    Pipeline(QObject* parent=nullptr);
    Pipeline(int id, QObject* parent=nullptr);
    Pipeline(QJsonObject json);

    // Getters
    inline int id() const { return mId; }
    inline bool starred() const { return mStarred; }
    inline QString name() const { return mName; }
    inline QString type() const { return mType; }
    inline QString status() const { return mStatus; }
    inline QString description() const { return mDescription; }
    inline QDateTime installationDate() const { return mInstallationDate; }
    inline QString version() const { return mVersion; }
    inline QString icon() const { return mIcon.toString(); }
    inline QString form() const { return mForm.toString(); }
    inline QString helpPage() const { return mHelpPage.toString(); }
    inline QString aboutPage() const { return mAboutPage.toString(); }
    inline QString license() const { return mLicense.toString(); }
    inline QString readme() const { return mReadme.toString(); }
    inline QString manifest() const { return mManifest.toString(); }
    inline DynamicFormModel* configForm() const { return mConfigForm; }

    Q_INVOKABLE inline QJsonObject manifestJson() const { return mManifestJson; }
    Q_INVOKABLE inline QJsonObject formJson() const { return mFormJson; }

    // Setters
    Q_INVOKABLE inline void setStarred(bool flag) { mStarred = flag; emit dataChanged();}

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Load pipeline information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;
    //! Ask the server to install this pipeline
    Q_INVOKABLE void install();


Q_SIGNALS:
    void neverChanged();

public Q_SLOTS:
    void updateSearchField() override;

private:
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
    QUrl mAboutPage;
    QUrl mLicense;
    QUrl mReadme;
    QUrl mManifest;

    QJsonObject mManifestJson;
    QJsonObject mFormJson;

    //! The form model to configure the pipeline
    DynamicFormModel* mConfigForm = nullptr;

    static QHash<QString, QString> mTypeIconMap;
    static QHash<QString, QString> initTypeIconMap();
};

#endif // PIPELINE_H
