#ifndef PANEL_H
#define PANEL_H

#include <QtCore>

class Panel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString owner READ owner NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(bool shared READ shared NOTIFY dataChanged)
    Q_PROPERTY(QStringList versions READ versions NOTIFY dataChanged)
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)

    Q_PROPERTY(QString currentVersion READ currentVersion NOTIFY dataChanged)
    Q_PROPERTY(QVariantList currentEntries READ currentEntries NOTIFY dataChanged)


public:
    // Constructors
    explicit Panel(QObject* parent=nullptr);
    explicit Panel(int id, QObject* parent=nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString name() const { return mName; }
    inline QString owner() const { return mOwner; }
    inline QString description() const { return mDescription; }
    inline bool shared() const { return mShared; }
    inline QStringList versions() const { return mVersions; }
    inline QDateTime creationDate() const { return mCreationDate; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QString currentVersion() const { return mCurrentVersion; }
    inline QVariantList currentEntries() const { return mCurrentEntries; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load();

    //! Add a new entry to the list (only used by the qml wizard)
    Q_INVOKABLE void addEntry(QJsonObject data);


Q_SIGNALS:
    void dataChanged();

private:
    int mId = -1;
    QString mName;
    QString mOwner;
    QString mDescription;
    bool mShared = false;
    QStringList mVersions;
    QHash<QString, QVariantList> mEntries;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;

    QString mCurrentVersion;
    QVariantList mCurrentEntries;
};

#endif // PANEL_H
