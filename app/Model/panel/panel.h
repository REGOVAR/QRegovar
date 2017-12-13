#ifndef PANEL_H
#define PANEL_H

#include <QtCore>
#include "panelversion.h"

class Panel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY dataChanged)
    Q_PROPERTY(QStringList versionsId READ versionsId NOTIFY dataChanged)
    Q_PROPERTY(bool shared READ shared WRITE setShared NOTIFY dataChanged)
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)

    Q_PROPERTY(QString currentVersion READ currentVersion WRITE setCurrentVersion NOTIFY dataChanged)
    Q_PROPERTY(QVariantList currentEntries READ currentEntries NOTIFY dataChanged)


public:
    // Constructors
    explicit Panel(QObject* parent=nullptr);
    explicit Panel(QString id, QObject* parent=nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString name() const { return mName; }
    inline QString owner() const { return mOwner; }
    inline QString description() const { return mDescription; }
    inline QStringList versionsId() const { return mOrderedVersionsId; }
    inline bool shared() const { return mShared; }
    inline QDateTime creationDate() const { return mCreationDate; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QString currentVersion() const { return mCurrentVersion; }
    inline QVariantList currentEntries() const { return mCurrentEntries; }

    // Setters
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setOwner(QString owner) { mOwner = owner; emit dataChanged(); }
    inline void setDescription(QString desc) { mDescription = desc; emit dataChanged(); }
    inline void setShared(bool flag) { mShared = flag; emit dataChanged(); }
    inline void setCurrentVersion(QString version) { mCurrentVersion = version; emit dataChanged(); }

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
    //! Reset data (only used by Creation wizard to reset its model)
    Q_INVOKABLE void reset();
    //! Return panel version details if provided id match; otherwise return null
    inline PanelVersion* getVersion(QString id) const { return (mEntries.contains(id)) ? mEntries[id] : nullptr; }


Q_SIGNALS:
    void dataChanged();

private:
    QString mId;
    QString mName;
    QString mOwner;
    QString mDescription;
    bool mShared = false;
    QStringList mOrderedVersionsId;
    QHash<QString, PanelVersion*> mEntries;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;

    QString mCurrentVersion;
    QVariantList mCurrentEntries;
};

#endif // PANEL_H
