#ifndef FILEMODEL_H
#define FILEMODEL_H

#include <QtCore>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>

class FileModel : public QObject
{

    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameUpdated)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentUpdated)
    Q_PROPERTY(QUrl url READ url)
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY updateDateUpdated)
    Q_PROPERTY(qint64 size READ size WRITE setSize NOTIFY sizeUpdated)
    Q_PROPERTY(qint64 uploadOffset READ uploadOffset WRITE setUploadOffset NOTIFY uploadOffsetUpdated)
    Q_PROPERTY(QString md5Sum READ md5Sum WRITE setMd5Sum NOTIFY md5SumUpdated)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeUpdated)
    Q_PROPERTY(FileStatus status READ status WRITE setStatus NOTIFY statusUpdated)
    Q_PROPERTY(QList<QString> tags READ tags NOTIFY tagsUpdated)

public:
    enum FileStatus
    {
        uploading,
        uploaded,
        checked,
        error
    };
    Q_ENUM(FileStatus)



    FileModel(QObject* parent=0);

    bool fromJson(QJsonDocument json);
    bool fromJson(QJsonObject json);

    // Accessors
    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString comment() { return mComment; }
    inline QUrl url() { return mUrl; }
    inline QDateTime creationDate() { return mCreationDate; }
    inline QDateTime updateDate() { return mUpdateDate; }
    inline qint64 size() { return mSize; }
    inline qint64 uploadOffset() { return mUploadOffset; }
    inline QString md5Sum() { return mMd5Sum; }
    inline QString type() { return mType; }
    inline FileStatus status() { return mStatus; }
    inline QList<QString> tags() { return mTags; }

    // Setters
    inline void setComment(QString comment) { mComment = comment; emit commentUpdated(); }
    inline void setName(QString name) { mName = name; emit nameUpdated(); }
    inline void setSize(qint64 size) { mSize = size; emit sizeUpdated(); }
    inline void setUploadOffset(qint64 uploadOffset) { mUploadOffset = uploadOffset; emit uploadOffsetUpdated(); }
    inline void setMd5Sum(QString md5Sum) { mMd5Sum = md5Sum; emit md5SumUpdated(); }
    inline void setType(QString type) { mType = type; emit typeUpdated(); }
    inline void setStatus(FileStatus status) { mStatus = status; emit statusUpdated(); }





//public Q_SLOTS:



Q_SIGNALS:
    void nameUpdated();
    void commentUpdated();
    void updateDateUpdated();
    void sizeUpdated();
    void uploadOffsetUpdated();
    void md5SumUpdated();
    void typeUpdated();
    void statusUpdated();
    void tagsUpdated();




private:
    // Attributes
    int mId;
    QUrl mUrl;
    QDateTime mCreationDate;
    QDateTime mUpdateDate;
    QString mComment;
    QString mName;
    QString mMd5Sum;
    QString mType;
    FileStatus mStatus;
    qint64 mSize;
    qint64 mUploadOffset;
    QList<QString> mTags;
    //QJob* mSource;

    QString mLocalPath;

    // mJobs
    // mEvents
    // mProjects
    // mSubjects

    // Methods
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit updateDateUpdated(); }

};

#endif // FILEMODEL_H

