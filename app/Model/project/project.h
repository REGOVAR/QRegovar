#ifndef PROJECT_H
#define PROJECT_H

#include <QtCore>

class Project : public QObject
{
    Q_OBJECT
    // Regovar resource attributes
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    // project attributes
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(Project* parent READ parent WRITE setParent NOTIFY dataChanged)
    Q_PROPERTY(bool isSandbox READ isSandbox)
    Q_PROPERTY(bool isFolder READ isFolder)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString fullPath READ fullPath NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> analyses READ analyses NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> subjects READ subjects NOTIFY dataChanged)


public:
    // Constructors
    explicit Project(QObject* parent=nullptr);
    explicit Project(int id, QObject *parent = nullptr);
    explicit Project(QJsonObject json, QObject *parent = nullptr);

    // Getters
    inline bool loaded() const { return mLoaded; }
    inline QDateTime createDate() const { return mCreateDate; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline int id() const { return mId; }
    inline Project* parent() const { return mParent; }
    inline bool isSandbox() const { return mIsSandbox; }
    inline bool isFolder() const { return mIsFolder; }
    inline QString name() const { return mName; }
    inline QString comment() const { return mComment; }
    inline QString fullPath() const { return mFullPath; }
    inline QList<QObject*> analyses() const { return mAnalyses; }
    inline QList<QObject*> subjects() const { return mSubjects; }

    // Setters
    inline void setParent(Project* parent) { mParent = parent; emit dataChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setName(QString name) { mName = name; emit dataChanged(); }


    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true);


    void buildAnalysis(QJsonObject json);
    void buildEvent(QJsonObject json);


Q_SIGNALS:
    void dataChanged();




private:
    bool mLoaded = false;
    QDateTime mCreateDate;
    QDateTime mUpdateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();
    // Attributes
    int mId = -1;
    bool mIsSandbox = false;
    bool mIsFolder = false;
    QString mFullPath;
    Project* mParent = nullptr;
    QString mComment;
    QString mName;
    QList<QObject*> mAnalyses;
    QList<QObject*> mSubjects;

    // Methods
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit dataChanged(); }

};

#endif // PROJECT_H

