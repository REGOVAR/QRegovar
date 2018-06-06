#ifndef PROJECT_H
#define PROJECT_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/analysis/analyseslistmodel.h"
#include "Model/subject/subjectslistmodel.h"

class Project : public RegovarResource
{
    Q_OBJECT
    // project attributes
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(Project* parent READ parent WRITE setParent NOTIFY dataChanged)
    Q_PROPERTY(bool isSandbox READ isSandbox)
    Q_PROPERTY(bool isFolder READ isFolder)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString fullPath READ fullPath NOTIFY dataChanged)
    Q_PROPERTY(AnalysesListModel* analyses READ analyses NOTIFY dataChanged)
    Q_PROPERTY(SubjectsListModel* subjects READ subjects NOTIFY dataChanged)




public:
    // Constructors
    Project(QObject* parent=nullptr);
    Project(int id, QObject *parent = nullptr);
    Project(QJsonObject json, QObject *parent = nullptr);

    // Getters
    inline int id() const { return mId; }
    inline Project* parent() const { return mParent; }
    inline bool isSandbox() const { return mIsSandbox; }
    inline bool isFolder() const { return mIsFolder; }
    inline QString name() const { return mName; }
    inline QString comment() const { return mComment; }
    inline QString fullPath() const { return mFullPath; }
    inline AnalysesListModel* analyses() const { return mAnalyses; }
    inline SubjectsListModel* subjects() const { return mSubjects; }

    // Setters
    inline void setParent(Project* parent) { mParent = parent; emit dataChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setName(QString name) { mName = name; emit dataChanged(); }


    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save project information onto server
    Q_INVOKABLE void save() override;
    //! Load project information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;


    void buildAnalysis(QJsonObject json);
    void buildEvent(QJsonObject json);



private:
    // Attributes
    int mId = -1;
    bool mIsSandbox = false;
    bool mIsFolder = false;
    QString mFullPath;
    Project* mParent = nullptr;
    QString mComment;
    QString mName;
    AnalysesListModel* mAnalyses = nullptr;
    SubjectsListModel* mSubjects;

    // Methods
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit dataChanged(); }

};

#endif // PROJECT_H

