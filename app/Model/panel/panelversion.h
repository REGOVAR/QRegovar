#ifndef PANELVERSION_H
#define PANELVERSION_H

#include <QtCore>

class Panel;

class PanelVersion: public QObject
{
    Q_OBJECT
    Q_PROPERTY(Panel* panel READ panel NOTIFY dataChanged)
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY dataChanged)
    Q_PROPERTY(QString version READ version WRITE setVersion NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QVariantList entries READ entries NOTIFY dataChanged)
    Q_PROPERTY(QDateTime creationDate READ creationDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)

public:
    // Constructors
    explicit PanelVersion(Panel* panel);
    explicit PanelVersion(QJsonObject json, Panel* panel);

    // Getters
    inline Panel* panel() const { return mPanel; }
    inline QString id() const { return mId; }
    inline QString version() const { return mVersion; }
    inline QString comment() const { return mComment; }
    inline QVariantList entries() const { return mEntries; }
    inline QDateTime creationDate() const { return mCreationDate; }
    inline QDateTime updateDate() const { return mUpdateDate; }

    // Setters
    inline void setId(QString i) { mId = i; emit dataChanged(); }
    inline void setVersion(QString v) { mVersion = v; emit dataChanged(); }
    inline void setComment(QString c) { mComment = c; emit dataChanged(); }




Q_SIGNALS:
    void dataChanged();

private:
    Panel* mPanel = nullptr;
    QString mId;
    QString mVersion;
    QString mComment;
    QVariantList mEntries;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;


};

#endif // PANELVERSION_H
