#ifndef PANEL_H
#define PANEL_H

#include <QtCore>
#include "panelversion.h"

class Panel : public QObject
{
    Q_OBJECT
    // Regovar resource attributes
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    // Panel attributes
    Q_PROPERTY(QString panelId READ panelId WRITE setPanelId)
    Q_PROPERTY(QString versionId READ versionId)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString version READ version WRITE setVersion NOTIFY dataChanged)
    Q_PROPERTY(QString fullname READ fullname NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QVariantList entries READ entries NOTIFY dataChanged)
    // Common panel's versions properties
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY dataChanged)
    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY dataChanged)
    Q_PROPERTY(bool shared READ shared WRITE setShared NOTIFY dataChanged)
    // List of others versions of this panel
    Q_PROPERTY(QStringList versionsIds READ versionsIds NOTIFY dataChanged)

public:
    // Panel factory
    static Panel* buildPanel(QJsonObject json);

    // Constructors
    explicit Panel(bool rootPanel=false, QObject* parent=nullptr);
    explicit Panel(QStringList* orderedVersions, QHash<QString, Panel*>* map, QObject* parent=nullptr);

    // Getters
    inline bool loaded() const { return mLoaded; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }

    inline QString panelId() const { return mPanelId; }
    inline QString versionId() const { return mVersionId; }
    inline QString name() const { return mName; }
    inline QString version() const { return mVersion; }
    inline QString fullname() const { return QString("%1 (%2)").arg(mName, mVersion); }
    inline QString comment() const { return mComment; }
    inline QVariantList entries() const { return mEntries; }
    inline QString description() const { return mDescription; }
    inline QString owner() const { return mOwner; }
    inline bool shared() const { return mShared; }
    inline QStringList versionsIds() const { return *mOrderedVersionsIds; }
    // Setters
    inline void setPanelId(QString id) { mPanelId = id; }
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setVersion(QString version) { mVersion = version; emit dataChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setDescription(QString desc) { mDescription = desc; emit dataChanged(); }
    inline void setOwner(QString owner) { mOwner = owner; emit dataChanged(); }
    inline void setShared(bool flag) { mShared = flag; emit dataChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true);


    //! Add a new version to the panel (append=true should be only used by factory)
    Q_INVOKABLE QString addVersion(QJsonObject data, bool append=false);
    //! Add a new entry to the list (only used by the qml wizard)
    Q_INVOKABLE void addEntry(QJsonObject data);
    //! Remove entry at the given index in the list (only used by the qml wizard)
    Q_INVOKABLE inline void removeEntryAt(int idx) { if (mEntries.count() > idx) mEntries.removeAt(idx); emit dataChanged(); }
    //! Remove entry at the given index in the list (only used by the qml wizard)
    Q_INVOKABLE inline void removeAllEntries() { mEntries.clear(); emit dataChanged(); }
    //! Reset data (only used by Creation wizard to reset its model)
    Q_INVOKABLE void reset();
    //! Return panel version details if provided id match; otherwise return null
    Q_INVOKABLE inline Panel* getVersion(QString versionId) const { return mVersionsMap->contains(versionId) ? mVersionsMap->value(versionId): nullptr; }


Q_SIGNALS:
    void dataChanged();

private:
    bool mLoaded = false;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    QString mPanelId;
    QString mVersionId;
    QString mName;
    QString mVersion;
    QString mComment;
    QVariantList mEntries;
    QString mDescription;
    QString mOwner;
    bool mShared = false;

    // Internal attributes (take care, they are shared by all panel's version of the same panel)
    QStringList* mOrderedVersionsIds;
    QHash<QString, Panel*>* mVersionsMap;
};

#endif // PANEL_H
