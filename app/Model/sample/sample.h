#ifndef SAMPLE_H
#define SAMPLE_H

#include <QtCore>
#include "Model/file/file.h"


class Sample : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString nickname READ nickname WRITE setNickname NOTIFY nicknameChanged)
    Q_PROPERTY(bool isMosaic READ isMosaic WRITE setIsMosaic NOTIFY isMosaicChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentChanged)
    Q_PROPERTY(QStringList defaultAnnotationsDbUid READ defaultAnnotationsDbUid NOTIFY defaultAnnotationsDbUidChanged)
    Q_PROPERTY(SampleStatus status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(File* source READ source WRITE setSource NOTIFY sourceChanged)
    // special "shortcut" property for qml tableView
    Q_PROPERTY(QVariant nameUI READ nameUI WRITE setNameUI NOTIFY nameUIChanged)
    Q_PROPERTY(QVariant subjectUI READ subjectUI WRITE setSubjectUI NOTIFY subjectUIChanged)
    Q_PROPERTY(QVariant statusUI READ statusUI WRITE setStatusUI NOTIFY statusUIChanged)
    Q_PROPERTY(QVariant sourceUI READ sourceUI WRITE setSourceUI NOTIFY sourceUIChanged)


public:
    enum SampleStatus
    {
        empty = 0,
        loading,
        ready,
        error
    };
    Q_ENUM(SampleStatus)


    explicit Sample(QObject *parent = nullptr);
    explicit Sample(int id, QString name, QString nickname, QObject *parent = nullptr);

    // Getters
    inline int id() { return mId; }
    inline QString name() { return mName; }
    inline QString nickname() { return mNickname; }
    inline QString comment() { return mComment; }
    inline SampleStatus status() { return mStatus; }
    inline bool isMosaic() { return mIsMosaic; }
    inline File* source() { return mSource; }
    inline QStringList defaultAnnotationsDbUid() { return mDefaultAnnotationsDbUid; }
    inline QVariant nameUI() { return mNameUI; }
    inline QVariant subjectUI() { return mSubjectUI; }
    inline QVariant statusUI() { return mStatusUI; }
    inline QVariant sourceUI() { return mSourceUI; }

    // Setters
    inline void setName(QString name) { mName = name; emit nameChanged(); }
    inline void setNickname(QString nickname) { mNickname = nickname; emit nicknameChanged(); }
    inline void setIsMosaic(bool flag) { mIsMosaic = flag; emit isMosaicChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit commentChanged(); }
    inline void setSource(File* source) { mSource = source; emit sourceChanged(); }
    inline void setStatus(SampleStatus status) { mStatus = status; emit statusChanged(); }
    inline void setNameUI(QVariant data) { mNameUI = data; emit nameUIChanged(); }
    inline void setSubjectUI(QVariant data) { mSubjectUI = data; emit subjectUIChanged(); }
    inline void setStatusUI(QVariant data) { mStatusUI = data; emit statusUIChanged(); }
    inline void setSourceUI(QVariant data) { mSourceUI = data; emit sourceUIChanged(); }

    // Methods
    Q_INVOKABLE bool fromJson(QJsonObject json);
    QString statusToLabel(SampleStatus status, double progress);

Q_SIGNALS:
    void nameChanged();
    void nicknameChanged();
    void isMosaicChanged();
    void commentChanged();
    void defaultAnnotationsDbUidChanged();
    void nameUIChanged();
    void subjectUIChanged();
    void statusUIChanged();
    void sourceUIChanged();
    void sourceChanged();
    void statusChanged();

public Q_SLOTS:

private:
    int mId;
    QString mName;
    QString mNickname;
    bool mIsMosaic;
    QString mComment;
    QStringList mDefaultAnnotationsDbUid;
    File* mSource;
    SampleStatus mStatus;

    QVariant mNameUI;
    QVariant mSubjectUI;
    QVariant mStatusUI;
    QVariant mSourceUI;
};

#endif // SAMPLE_H
