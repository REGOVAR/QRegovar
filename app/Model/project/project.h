#ifndef PROJECT_H
#define PROJECT_H

#include <QtCore>

#include "Model/file/filestreemodel.h"

class Project : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(Project* parent READ parent WRITE setParent NOTIFY dataChanged)
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(bool isSandbox READ isSandbox)
    Q_PROPERTY(bool isFolder READ isFolder)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(FilesTreeModel* files READ files NOTIFY dataChanged)
    Q_PROPERTY(QString fullPath READ fullPath NOTIFY dataChanged)


public:
    Project(QObject* parent=0);
    Project(bool isFolder, bool isSandbox, QObject* parent=0);

    bool fromJson(QJsonDocument json);
    bool fromJson(QJsonObject json);

    // Accessors
    inline int id() { return mId; }
    inline Project* parent() { return mParent; }
    inline QDateTime creationDate() { return mCreationDate; }
    inline QDateTime updateDate() { return mUpdateDate; }
    inline bool isSandbox() { return mIsSandbox; }
    inline bool isFolder() { return mIsFolder; }
    inline QString name() { return mName; }
    inline QString comment() { return mComment; }
    inline FilesTreeModel* files() { return mFiles; }
    inline QString fullPath() { return mFullPath; }

    // Setters
    void setParent(Project* parent);
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setName(QString name) { mName = name; emit dataChanged(); }



//public Q_SLOTS:



Q_SIGNALS:
    void dataChanged();




private:
    // Attributes
    int mId;
    bool mIsSandbox;
    bool mIsFolder;
    QString mFullPath;
    Project* mParent;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;
    QString mComment;
    QString mName;

    FilesTreeModel* mFiles;
    // mUserRights
    // mindicators
    // mJobs
    // mAnalyses
    // mEvents

    // Methods
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit dataChanged(); }

};

#endif // PROJECT_H

