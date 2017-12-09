#ifndef PANELVERSION_H
#define PANELVERSION_H

#include <QtCore>

class PanelVersion: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString version READ version WRITE setVersion NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QVariantList entries READ entries NOTIFY dataChanged)
    Q_PROPERTY(QDateTime creationDate READ creationDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)

public:
    // Constructors
    explicit PanelVersion(QObject* parent=nullptr);
    explicit PanelVersion(QJsonObject json, QObject* parent=nullptr);

    // Getters
    inline QString version() const { return mVersion; }
    inline QString comment() const { return mComment; }
    inline QVariantList entries() const { return mEntries; }
    inline QDateTime creationDate() const { return mCreationDate; }
    inline QDateTime updateDate() const { return mUpdateDate; }

    // Setters
    inline void setVersion(QString v) { mVersion = v; emit dataChanged(); }
    inline void setComment(QString c) { mComment = c; emit dataChanged(); }




Q_SIGNALS:
    void dataChanged();

private:
    QString mVersion;
    QString mComment;
    QVariantList mEntries;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;


};

#endif // PANELVERSION_H
