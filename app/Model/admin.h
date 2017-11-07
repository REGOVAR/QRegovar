#ifndef ADMIN_H
#define ADMIN_H

#include <QtCore>


class AdminTableInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString section READ section NOTIFY dataChanged)
    Q_PROPERTY(QString table READ table NOTIFY dataChanged)
    Q_PROPERTY(QString description READ description NOTIFY dataChanged)
    Q_PROPERTY(int count READ count NOTIFY dataChanged)
    Q_PROPERTY(int size READ size NOTIFY dataChanged)
    Q_PROPERTY(int realSize READ realSize NOTIFY dataChanged)
    Q_PROPERTY(bool clearable READ clearable NOTIFY dataChanged)

public:
    explicit AdminTableInfo(QObject* parent = nullptr);
    explicit AdminTableInfo(QJsonObject json, QObject* parent = nullptr);

    // Getters
    inline QString section() { return mSection; }
    inline QString table() { return mTable; }
    inline QString description() { return mDescription; }
    inline int count() { return mCount; }
    inline int size() { return mSize; }
    inline int realSize() { return mRealSize; }
    inline bool clearable() { return mClearable; }

Q_SIGNALS:
    void dataChanged();

private:
    QString mSection;
    QString mTable;
    QString mDescription;
    int mCount;
    int mSize;
    int mRealSize;
    bool mClearable;
};















/*!
 * \brief Handle Regovar administration features.
 */
class Admin : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool serverStatusAutoRefresh READ serverStatusAutoRefresh WRITE setServerStatusAutoRefresh NOTIFY serverStatusAutoRefreshChanged)
    Q_PROPERTY(QJsonObject serverStatus READ serverStatus NOTIFY serverStatusChanged)
    Q_PROPERTY(QList<QObject*> tables READ tables NOTIFY tablesChanged)
    Q_PROPERTY(int tablesTotalSize READ tablesTotalSize NOTIFY tablesChanged)
    Q_PROPERTY(QVariantList tablesSizes READ tablesSizes NOTIFY tablesChanged)
    Q_PROPERTY(QVariantList wtTables READ wtTables NOTIFY tablesChanged)

public:
    explicit Admin(QObject* parent = nullptr);

    // Getters
    inline bool serverStatusAutoRefresh() { return mServerStatusAutoRefresh; }
    inline QJsonObject serverStatus() { return mServerStatus; }
    inline QList<QObject*> tables() { return mTables; }
    inline int tablesTotalSize() { return mTablesTotalSize; }
    inline QVariantList  tablesSizes() { return mSectionsSizes; }
    inline QVariantList  wtTables() { return mWtTables; }
    // Setters
    inline void setServerStatusAutoRefresh(bool flag) { mServerStatusAutoRefresh=flag; emit serverStatusAutoRefreshChanged(); }
    inline void setServerStatus(QJsonObject json) { mServerStatus=json; emit serverStatusChanged(); }
    // Methods
    Q_INVOKABLE void getServerStatus();
    Q_INVOKABLE void refreshServerStatus();
    Q_INVOKABLE void clearWt(int analysisId);



Q_SIGNALS:
    void serverStatusAutoRefreshChanged();
    void serverStatusChanged();
    void tablesChanged();
private:
    bool mServerStatusAutoRefresh;
    QJsonObject mServerStatus;
    QList<QObject*> mTables;
    int mTablesTotalSize;
    QVariantList  mSectionsSizes;
    QVariantList  mWtTables;
};







#endif // ADMIN_H
