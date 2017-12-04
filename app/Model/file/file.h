#ifndef FILE_H
#define FILE_H

#include <QtCore>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>

class File : public QObject
{
    Q_OBJECT
    // File attributes
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentChanged)
    Q_PROPERTY(QUrl url READ url)
    Q_PROPERTY(QString md5Sum READ md5Sum WRITE setMd5Sum NOTIFY md5SumChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QList<QString> tags READ tags NOTIFY tagsChanged)
    // Remote file attributes
    Q_PROPERTY(QDateTime creationDate READ creationDate)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY updateDateChanged)
    Q_PROPERTY(qint64 size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(qint64 uploadOffset READ uploadOffset WRITE setUploadOffset NOTIFY uploadOffsetChanged)
    Q_PROPERTY(FileStatus status READ status WRITE setStatus NOTIFY statusChanged)
    // Local file attributes
    Q_PROPERTY(QString localFilePath READ localFilePath NOTIFY localFilePathChanged)
    Q_PROPERTY(bool localFileReady READ localFileReady NOTIFY localFileReadyChanged)
    Q_PROPERTY(qint64 downloadOffset READ downloadOffset WRITE setDownloadOffset NOTIFY downloadOffsetChanged)
    Q_PROPERTY(FileStatus localStatus READ localStatus WRITE setLocalStatus NOTIFY localStatusChanged)

    // Property for QML quick display in tableView
    Q_PROPERTY(QVariant filenameUI READ filenameUI NOTIFY filenameUIChanged)
    Q_PROPERTY(QVariant statusUI READ statusUI NOTIFY statusUIChanged)
    Q_PROPERTY(QString sizeUI READ sizeUI NOTIFY sizeUIChanged)
    Q_PROPERTY(QString sourceUI READ sourceUI NOTIFY sourceUIChanged)

public:
    enum FileStatus
    {
        uploading=0,
        uploaded,
        checked,
        error,
        downloading,
        downloaded,
    };
    Q_ENUM(FileStatus)


    // Constructors
    File(QObject* parent=nullptr);
    File(QJsonObject json, QObject* parent=nullptr);
    File(int id, QObject* parent=nullptr);

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

    inline QString localFilePath() { return mLocalPath; }
    inline bool localFileReady() { return mLocalFileReady; }
    inline qint64 downloadOffset() { return mDownloadOffset; }
    inline FileStatus localStatus() { return mLocalStatus; }

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
    inline void setUpdateDate(QDateTime date) { mUpdateDate = date; emit updateDateChanged(); }

    inline void setDownloadOffset(qint64 offset) { mDownloadOffset = offset; emit downloadOffset(); }
    inline void setLocalStatus(FileStatus status) { mLocalStatus = status; emit localStatusChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonDocument json);
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true);
    //! Dowload the file and put it in cache. When file is ready, the localFileReadyChanged signal is emit
    Q_INVOKABLE bool downloadLocalFile();
    //! Read file content as QString
    Q_INVOKABLE QString readFile();

    //! Helper to compute all-in-one property to display file in the UI.
    Q_INVOKABLE static QString extensionToIco(QString ext);
    Q_INVOKABLE QString statusToLabel(FileStatus status, qint64 size, qint64 uploadOffset);




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

    void localFilePathChanged();
    void localFileReadyChanged();
    void downloadOffsetChanged();
    void localStatusChanged();

    void filenameUIChanged();
    void sizeUIChanged();
    void sourceUIChanged();
    void statusUIChanged();




private:
    // Attributes
    int mId = -1;
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

    QString mLocalPath;
    bool mLocalFileReady = false;
    qint64 mDownloadOffset;
    FileStatus mLocalStatus;


    // UI all-in-one attributes
    QVariant mFilenameUI;
    QString mSizeUI;
    QVariant mStatusUI;
    QString mSourceUI;

    // Internal
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    // TODO: static collection
    static QStringList zip;
    static QStringList txt;
    static QStringList src;
    static QStringList aud;
    static QStringList vid;
    static QStringList img;
    static QStringList xls;
    static QStringList doc;
    static QStringList prz;
    static QStringList pdf;
};

#endif // FILE_H

