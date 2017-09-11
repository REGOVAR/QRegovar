#ifndef FILE_H
#define FILE_H

#include <QtCore>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>

class File : public QObject
{

    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentChanged)
    Q_PROPERTY(QUrl url READ url)
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY updateDateChanged)
    Q_PROPERTY(qint64 size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(qint64 uploadOffset READ uploadOffset WRITE setUploadOffset NOTIFY uploadOffsetChanged)
    Q_PROPERTY(QString md5Sum READ md5Sum WRITE setMd5Sum NOTIFY md5SumChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(FileStatus status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QList<QString> tags READ tags NOTIFY tagsChanged)

    // Property for QML quick display in tableView
    Q_PROPERTY(QVariant filenameUI READ filenameUI NOTIFY filenameUIChanged)
    Q_PROPERTY(QVariant statusUI READ statusUI NOTIFY statusUIChanged)
    Q_PROPERTY(QString sizeUI READ sizeUI NOTIFY sizeUIChanged)
    Q_PROPERTY(QString sourceUI READ sourceUI NOTIFY sourceUIChanged)

public:
    enum FileStatus
    {
        uploading = 0,
        uploaded,
        checked,
        error
    };
    Q_ENUM(FileStatus)



    File(QObject* parent=0);

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

    inline QVariant filenameUI() { return mFilenameUI; }
    inline QVariant statusUI() { return mStatusUI; }
    inline QString sizeUI() { return mSizeUI; }
    inline QString sourceUI() { return mSourceUI; }


    // Setters
    inline void setComment(QString comment) { mComment = comment; emit commentChanged(); }
    inline void setName(QString name) { mName = name; emit nameChanged(); }
    inline void setSize(qint64 size) { mSize = size; emit sizeChanged(); }
    inline void setUploadOffset(qint64 uploadOffset) { mUploadOffset = uploadOffset; emit uploadOffsetChanged(); }
    inline void setMd5Sum(QString md5Sum) { mMd5Sum = md5Sum; emit md5SumChanged(); }
    inline void setType(QString type) { mType = type; emit typeChanged(); }
    inline void setStatus(FileStatus status) { mStatus = status; emit statusChanged(); }


    // Methods
    QString extensionToIco(QString ext);
    QString statusToLabel(FileStatus status, qint64 size, qint64 uploadOffset);
    QString sizeToHumanReadable(qint64 size, qint64 uploadOffset);


//public Q_SLOTS:



Q_SIGNALS:
    void nameChanged();
    void commentChanged();
    void updateDateChanged();
    void sizeChanged();
    void uploadOffsetChanged();
    void md5SumChanged();
    void typeChanged();
    void statusChanged();
    void tagsChanged();

    void filenameUIChanged();
    void sizeUIChanged();
    void sourceUIChanged();
    void statusUIChanged();




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
    // UI attribute
    QVariant mFilenameUI;
    QString mSizeUI;
    QVariant mStatusUI;
    QString mSourceUI;

    QString mLocalPath;

    // mJobs
    // mEvents
    // mProjects
    // mSubjects

    // Methods
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit updateDateChanged(); }

};

#endif // FILE_H

