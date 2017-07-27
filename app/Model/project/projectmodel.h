#ifndef PROJECTMODEL_H
#define PROJECTMODEL_H

#include <QtCore>

#include "Model/file/filestreeviewmodel.h"

class ProjectModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(ProjectModel* parent READ parent WRITE setParent NOTIFY parentUpdated)
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY updateDateUpdated)
    Q_PROPERTY(bool isSandbox READ isSandbox)
    Q_PROPERTY(bool isFolder READ isFolder)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentUpdated)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameUpdated)
    Q_PROPERTY(FilesTreeViewModel* files READ files NOTIFY filesUpdated)


public:
    ProjectModel(QObject* parent=0);
    ProjectModel(bool isFolder, bool isSandbox, QObject* parent=0);

    bool fromJson(QJsonDocument json);
    bool fromJson(QJsonObject json);

    // Accessors
    inline int id() { return mId; }
    inline ProjectModel* parent() { return mParent; }
    inline QDateTime creationDate() { return mCreationDate; }
    inline QDateTime updateDate() { return mUpdateDate; }
    inline bool isSandbox() { return mIsSandbox; }
    inline bool isFolder() { return mIsFolder; }
    inline QString name() { return mName; }
    inline QString comment() { return mComment; }
    inline FilesTreeViewModel* files() { return mFiles; }

    // Setters
    void setParent(ProjectModel* parent);
    inline void setComment(QString comment) { mComment = comment; emit commentUpdated(); }
    inline void setName(QString name) { mName = name; emit nameUpdated(); }



//public Q_SLOTS:



Q_SIGNALS:
    void parentUpdated();
    void updateDateUpdated();
    void commentUpdated();
    void nameUpdated();
    void filesUpdated();




private:
    // Attributes
    int mId;
    bool mIsSandbox;
    bool mIsFolder;
    QString mFullPath;
    ProjectModel* mParent;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;
    QString mComment;
    QString mName;

    FilesTreeViewModel* mFiles;
    // mUserRights
    // mindicators
    // mJobs
    // mAnalyses
    // mEvents

    // Methods
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit updateDateUpdated(); }

};

#endif // PROJECTMODEL_H

