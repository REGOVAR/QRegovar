#ifndef ANALYSIS_H
#define ANALYSIS_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/mainmenu/rootmenu.h"




class Analysis : public RegovarResource
{
    Q_OBJECT
    Q_PROPERTY(RootMenu* menuModel READ menuModel NOTIFY menuModelChanged)
    // Analysis attributes
    Q_PROPERTY(int id READ id WRITE setId NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type NOTIFY dataChanged)
    Q_PROPERTY(Project* project READ project WRITE setProject NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    // TODO: Indicators

public:
    // enum value returned by the server as analysis type
    static QString FILTERING;
    static QString PIPELINE;

    // Constructors
    Analysis(QObject *parent = nullptr);

    // Getters
    inline RootMenu* menuModel() const { return mMenuModel; }

    inline int id() const { return mId; }
    inline QString name() const { return mName; }
    inline QString comment() const { return mComment; }
    inline QString type() const { return mType; }
    inline Project* project() const { return mProject; }
    inline QString status() const { return mStatus; }

    // Setters
    inline void setId(int id) { mId = id; emit dataChanged(); }
    inline void setName(const QString& name) { mName = name; emit dataChanged(); }
    inline void setComment(const QString& comment) { mComment = comment; emit dataChanged(); }
    inline void setProject(Project* project) { mProject = project; emit dataChanged(); }
    inline void setStatus(const QString& status) { mStatus = status; emit statusChanged(); }

    // Static Methods
    Q_INVOKABLE static QString statusLabel(QString status);
    Q_INVOKABLE static QString statusIcon(QString status);
    Q_INVOKABLE static bool statusIconAnimated(QString status);



Q_SIGNALS:
    void menuModelChanged();
    void statusChanged();


public Q_SLOTS:
    virtual void updateSearchField() override;

protected:
    RootMenu* mMenuModel = nullptr;
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
