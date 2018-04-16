#ifndef ANALYSIS_H
#define ANALYSIS_H

#include <QtCore>
#include "Model/mainmenu/rootmenu.h"




class Analysis : public QObject
{
    Q_OBJECT
    Q_PROPERTY(RootMenu* menuModel READ menuModel NOTIFY menuModelChanged)
    // Regovar resource attributes
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    // Analysis attributes
    Q_PROPERTY(int id READ id WRITE setId NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(Project* project READ project WRITE setProject NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)

public:
    // enum value returned by the server as analysis type
    static QString FILTERING;
    static QString PIPELINE;

    // Constructors
    explicit Analysis(QObject *parent = nullptr);

    // Getters
    inline RootMenu* menuModel() const { return mMenuModel; }
    inline bool loaded() const { return mLoaded; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }

    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString comment() { return mComment; }
    inline QString type() { return mType; }
    inline Project* project() const { return mProject; }
    inline QString status() const { return mStatus; }

    // Setters
    inline void setId(int id) { mId = id; emit dataChanged(); }
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setProject(Project* project) { mProject = project; emit dataChanged(); }
    inline void setStatus(QString status) { mStatus = status; emit statusChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE virtual bool loadJson(QJsonObject json, bool full_init=true) = 0;
    //! Export model data into json object
    Q_INVOKABLE virtual QJsonObject toJson() = 0;
    //! Save subject information onto server
    Q_INVOKABLE virtual void save() = 0;
    //! Load Subject information from server
    Q_INVOKABLE virtual void load(bool forceRefresh=true) = 0;



    Q_INVOKABLE static QString statusLabel(QString status);
    Q_INVOKABLE static QString statusIcon(QString status);
    Q_INVOKABLE static bool statusIconAnimated(QString status);



Q_SIGNALS:
    void menuModelChanged();
    void dataChanged();
    void statusChanged();



protected:
    RootMenu* mMenuModel = nullptr;
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
    Project* mProject = nullptr;
    QString mStatus; // status of the analysis (server side)

    static QHash<QString, QString> sStatusLabelMap;
    static QHash<QString, QString> sStatusIconMap;
    static QHash<QString, bool> sStatusAnimatedMap;
    static QHash<QString, QString> initStatusLabelMap();
    static QHash<QString, QString> initStatusIconMap();
    static QHash<QString, bool> initStatusAnimatedMap();
};

#endif // ANALYSIS_H
