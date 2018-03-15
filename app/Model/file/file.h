#ifndef FILE_H
#define FILE_H

#include <QtCore>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>

class File : public QObject
{
    Q_OBJECT

    // Regovar resource attribute
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    // File attributes
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QUrl url READ url)
    Q_PROPERTY(QString md5Sum READ md5Sum WRITE setMd5Sum NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY dataChanged)
    Q_PROPERTY(QString tags READ tags WRITE setTags NOTIFY dataChanged)
    // Remote file attributes
    Q_PROPERTY(qint64 size READ size WRITE setSize NOTIFY dataChanged)
    Q_PROPERTY(qint64 uploadOffset READ uploadOffset WRITE setUploadOffset NOTIFY dataChanged)
    Q_PROPERTY(FileStatus status READ status WRITE setStatus NOTIFY dataChanged)
    // Local file attributes
    Q_PROPERTY(QString localFilePath READ localFilePath NOTIFY dataChanged)
    Q_PROPERTY(bool localFileReady READ localFileReady NOTIFY localFileReadyChanged)
    Q_PROPERTY(qint64 downloadOffset READ downloadOffset WRITE setDownloadOffset NOTIFY dataChanged)
    Q_PROPERTY(FileStatus localStatus READ localStatus WRITE setLocalStatus NOTIFY dataChanged)

    // Property for QML quick display in tableView
    Q_PROPERTY(QVariant filenameUI READ filenameUI NOTIFY dataChanged)
    Q_PROPERTY(QVariant statusUI READ statusUI NOTIFY dataChanged)
    Q_PROPERTY(QString sizeUI READ sizeUI NOTIFY dataChanged)
    Q_PROPERTY(QString sourceUI READ sourceUI NOTIFY dataChanged)    
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

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
    inline bool loaded() const { return mLoaded; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }
    inline int id() const { return mId; }
    inline QString name() const { return mName; }
    inline QString comment() const { return mComment; }
    inline QUrl url() const { return mUrl; }
    inline qint64 size() const { return mSize; }
    inline qint64 uploadOffset() const { return mUploadOffset; }
    inline QString md5Sum() const { return mMd5Sum; }
    inline QString type() const { return mType; }
    inline FileStatus status() const { return mStatus; }
    inline QString tags() const { return mTags; }

    inline QString localFilePath() const { return mLocalPath; }
    inline bool localFileReady() const { return mLocalFileReady; }
    inline qint64 downloadOffset() const { return mDownloadOffset; }
    inline FileStatus localStatus() const { return mLocalStatus; }

    inline QVariant filenameUI() const { return mFilenameUI; }
    inline QVariant statusUI() const { return mStatusUI; }
    inline QString sizeUI() const { return mSizeUI; }
    inline QString sourceUI() const { return mSourceUI; }
    inline QString searchField() const { return mSearchField; }


    // Setters
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setTags(QString tags) { mTags = tags; emit dataChanged(); }
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setSize(qint64 size) { mSize = size; emit dataChanged(); }
    inline void setUploadOffset(qint64 uploadOffset) { mUploadOffset = uploadOffset; emit dataChanged(); }
    inline void setMd5Sum(QString md5Sum) { mMd5Sum = md5Sum; emit dataChanged(); }
    inline void setType(QString type) { mType = type; emit dataChanged(); }
    inline void setStatus(FileStatus status) { mStatus = status; emit dataChanged(); }

    inline void setDownloadOffset(qint64 offset) { mDownloadOffset = offset; emit downloadOffset(); }
    inline void setLocalStatus(FileStatus status) { mLocalStatus = status; emit dataChanged(); }

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
    //! Delete local cache file
    Q_INVOKABLE bool clearCache();

    //! Helper to compute all-in-one property to display file in the UI.
    Q_INVOKABLE static QString extensionToIco(QString ext);
    Q_INVOKABLE QString statusToLabel(FileStatus status, qint64 size, qint64 uploadOffset);




Q_SIGNALS:
    void dataChanged();
    void localFileReadyChanged();

public Q_SLOTS:
    void updateSearchField();

private:

    bool mLoaded = false;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    // Attributes
    int mId = -1;
    QUrl mUrl;
    QString mComment;
    QString mName;
    QString mMd5Sum;
    QString mType;
    FileStatus mStatus;
    qint64 mSize = 0;
    qint64 mUploadOffset = 0;
    QString mTags;

    QString mLocalPath;
    bool mLocalFileReady = false;
    qint64 mDownloadOffset = 0;
    FileStatus mLocalStatus;
    QString mSearchField;


    // UI all-in-one attributes
    QVariant mFilenameUI;
    QString mSizeUI;
    QVariant mStatusUI;
    QString mSourceUI;


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

