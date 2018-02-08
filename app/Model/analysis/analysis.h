#ifndef ANALYSIS_H
#define ANALYSIS_H

#include <QtCore>
#include "Model/mainmenu/rootmenumodel.h"




class Analysis : public QObject
{
    Q_OBJECT
    Q_PROPERTY(RootMenuModel* menuModel READ menuModel NOTIFY menuModelChanged)
    // Regovar resource attributes
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    // Analysis attributes
    Q_PROPERTY(int id READ id WRITE setId NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)

public:

    explicit Analysis(QObject *parent = nullptr);

    // Getters
    inline RootMenuModel* menuModel() const { return mMenuModel; }
    inline bool loaded() const { return mLoaded; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }

    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString comment() { return mComment; }
    inline QString type() { return mType; }

    // Setters
    Q_INVOKABLE inline void setId(int id) { mId = id; emit dataChanged(); }
    Q_INVOKABLE inline void setName(QString name) { mName = name; emit dataChanged(); }
    Q_INVOKABLE inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE virtual bool fromJson(QJsonObject json, bool full_init=true) = 0;
    //! Export model data into json object
    Q_INVOKABLE virtual QJsonObject toJson() = 0;
    //! Save subject information onto server
    Q_INVOKABLE virtual void save() = 0;
    //! Load Subject information from server
    Q_INVOKABLE virtual void load(bool forceRefresh=true) = 0;





Q_SIGNALS:
    void menuModelChanged();
    void dataChanged();



protected:
    RootMenuModel* mMenuModel = nullptr;
    // Regovar resource
    bool mLoaded = false;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();
    // Analysis attribute
    int mId = -1;
    QString mName;
    QString mComment;
    QString mType;

};

#endif // ANALYSIS_H
