#ifndef FILE_H
#define FILE_H

#include <QtCore>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>
#include "Model/framework/regovarresource.h"

class File : public RegovarResource
{
    Q_OBJECT
    // File attributes
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QUrl url READ url)
    Q_PROPERTY(QUrl viewerUrl READ viewerUrl)
    Q_PROPERTY(QString md5Sum READ md5Sum WRITE setMd5Sum NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY dataChanged)
    Q_PROPERTY(QString tags READ tags WRITE setTags NOTIFY dataChanged)
    // Remote file attributes
    Q_PROPERTY(qint64 size READ size WRITE setSize NOTIFY dataChanged)
    Q_PROPERTY(qint64 uploadOffset READ uploadOffset WRITE setUploadOffset NOTIFY dataChanged)
    Q_PROPERTY(QString status READ status WRITE setStatus NOTIFY dataChanged)
    // Property for QML quick display in tableView
    Q_PROPERTY(QVariant filenameUI READ filenameUI NOTIFY dataChanged)
    Q_PROPERTY(QVariant statusUI READ statusUI NOTIFY dataChanged)
    Q_PROPERTY(QString sizeUI READ sizeUI NOTIFY dataChanged)
    Q_PROPERTY(QString sourceUI READ sourceUI NOTIFY dataChanged)

public:
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
    inline QUrl viewerUrl() const { return mViewerUrl; }
    inline qint64 size() const { return mSize; }
    inline qint64 uploadOffset() const { return mUploadOffset; }
    inline QString md5Sum() const { return mMd5Sum; }
    inline QString type() const { return mType; }
    inline QString status() const { return mStatus; }
    inline QString tags() const { return mTags; }


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
    inline void setStatus(QString status) { mStatus = status; emit dataChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonDocument json);
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save event information onto server
    Q_INVOKABLE void save() override;
    Q_INVOKABLE inline void edit(QString name, QString tags, QString comment) {mName = name; mTags = tags;mComment = comment; emit dataChanged(); save(); }
    //! Load event information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;

    //! Helper to compute all-in-one property to display file in the UI.
    Q_INVOKABLE static QString extensionToIco(QString ext);
    Q_INVOKABLE QString statusToLabel(QString status, qint64 size, qint64 uploadOffset);
    Q_INVOKABLE QString getQMLViewer();


Q_SIGNALS:
    void localFileReadyChanged();


public Q_SLOTS:
    void updateSearchField() override;


private:
    // Attributes
    int mId = -1;
    QUrl mUrl;
    QUrl mViewerUrl;
    QString mComment;
    QString mName;
    QString mMd5Sum;
    QString mType;
    QString mStatus;
    qint64 mSize = 0;
    qint64 mUploadOffset = 0;
    QString mTags;


    // UI all-in-one attributes
    QVariant mFilenameUI;
    QString mSizeUI;
    QVariant mStatusUI;
    QString mSourceUI;

    // static collection to link file extension to a generic type
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
    static QStringList web;
};

#endif // FILE_H

