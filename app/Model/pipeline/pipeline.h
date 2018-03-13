#ifndef PIPELINE_H
#define PIPELINE_H

#include <QtCore>

class Pipeline : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(bool starred READ starred WRITE setStarred NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(QStringList authors READ authors NOTIFY dataChanged)
    Q_PROPERTY(QDateTime installationDate READ installationDate NOTIFY dataChanged)
    Q_PROPERTY(QString version READ version NOTIFY dataChanged)
    Q_PROPERTY(QString pirusApiVersion READ pirusApiVersion NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject form READ form NOTIFY dataChanged)



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
    inline QStringList authors() const { return mAuthors; }
    inline QDateTime installationDate() const { return mInstallationDate; }
    inline QString version() const { return mVersion; }
    inline QString pirusApiVersion() const { return mPirusApiVersion; }
    inline QJsonObject form() const { return mForm; }
    inline QString searchField() const { return mSearchField; }

    // Setters
    Q_INVOKABLE inline void setStarred(bool flag) { mStarred = flag; emit dataChanged();}

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Ask the server to install this pipeline
    Q_INVOKABLE void install();
    //! Load event information and related object from server
    Q_INVOKABLE void load(bool forceRefresh=true);


Q_SIGNALS:
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
    QStringList mAuthors;
    QDateTime mInstallationDate;
    QString mVersion;
    QString mPirusApiVersion;
    QJsonObject mForm;
    QString mSearchField;

    static QHash<QString, QString> mTypeIconMap;
    static QHash<QString, QString> initTypeIconMap();
};

#endif // PIPELINE_H
