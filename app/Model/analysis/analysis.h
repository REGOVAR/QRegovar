#ifndef ANALYSIS_H
#define ANALYSIS_H

#include <QtCore>




class Analysis : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentChanged)
    Q_PROPERTY(QString type READ type NOTIFY typeChanged)
    Q_PROPERTY(QDateTime lastUpdate READ lastUpdate WRITE setLastUpdate NOTIFY lastUpdateChanged)

public:

    explicit Analysis(QObject *parent = nullptr);

    // Getters
    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString comment() { return mComment; }
    inline QString type() { return mType; }
    inline QDateTime lastUpdate() { return mLastUpdate; }

    // Setters
    Q_INVOKABLE inline void setId(int id) { mId = id; emit idChanged(); }
    Q_INVOKABLE inline void setName(QString name) { mName = name; emit nameChanged(); }
    Q_INVOKABLE inline void setComment(QString comment) { mComment = comment; emit commentChanged(); }
    Q_INVOKABLE inline void setLastUpdate(QDateTime date) { mLastUpdate = date; emit lastUpdateChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE virtual bool fromJson(QJsonObject json, bool full_init=true) = 0;
    //! Export model data into json object
    Q_INVOKABLE virtual QJsonObject toJson() = 0;
    //! Save subject information onto server
    Q_INVOKABLE virtual void save() = 0;
    //! Load Subject information from server
    Q_INVOKABLE virtual void load() = 0;





Q_SIGNALS:
    void idChanged();
    void nameChanged();
    void commentChanged();
    void typeChanged();
    void lastUpdateChanged();



protected:
    int mId = -1;
    QString mName;
    QString mComment;
    QString mType;
    QDateTime mLastUpdate;

};

#endif // ANALYSIS_H
