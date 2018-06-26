#ifndef SAMPLE_H
#define SAMPLE_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/file/file.h"
#include "subject.h"
#include "reference.h"

class Subject;
class Sample : public RegovarResource
{
    Q_OBJECT
    // Sample attributes
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY dataChanged)
    Q_PROPERTY(QString nickname READ nickname WRITE setNickname NOTIFY dataChanged)
    Q_PROPERTY(bool isMosaic READ isMosaic WRITE setIsMosaic NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(QStringList defaultAnnotationsDbUid READ defaultAnnotationsDbUid NOTIFY dataChanged)
    Q_PROPERTY(SampleStatus status READ status WRITE setStatus NOTIFY dataChanged)
    Q_PROPERTY(File* source READ source WRITE setSource NOTIFY dataChanged)
    Q_PROPERTY(Subject* subject READ subject WRITE setSubject NOTIFY dataChanged)
    Q_PROPERTY(Reference* reference READ reference WRITE setReference NOTIFY dataChanged)
    Q_PROPERTY(double loadingProgress READ loadingProgress NOTIFY dataChanged)
    // special "shortcut" property for qml tableView
    Q_PROPERTY(QVariant nameUI READ nameUI WRITE setNameUI NOTIFY dataChanged)
    Q_PROPERTY(QVariant statusUI READ statusUI WRITE setStatusUI NOTIFY dataChanged)
    Q_PROPERTY(QVariant sourceUI READ sourceUI WRITE setSourceUI NOTIFY dataChanged)
    // Property only used client side by the newAnalysis wizard
    Q_PROPERTY(bool isIndex READ isIndex WRITE setIsIndex NOTIFY dataChanged)
    Q_PROPERTY(QString sex READ sex WRITE setSex NOTIFY dataChanged)

    Q_PROPERTY(QJsonObject stats READ stats NOTIFY dataChanged)

public:
    enum SampleStatus
    {
        empty = 0,
        loading,
        ready,
        error
    };
    Q_ENUM(SampleStatus)

    // Constructors
    Sample(QObject* parent = nullptr);
    Sample(int id, QObject* parent = nullptr);
    Sample(QJsonObject json, QObject* parent = nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString name() const { return mName; }
    inline QString nickname() const { return mNickname.isEmpty() ? mName : mNickname; }
    inline QString comment() const { return mComment; }
    inline SampleStatus status() const { return mStatus; }
    inline bool isMosaic() const { return mIsMosaic; }
    inline File* source() const { return mSource; }
    inline Subject* subject() const { return mSubject; }
    inline Reference* reference() const { return mReference; }
    inline double loadingProgress() const { return mLoadingProgress; }
    inline QStringList defaultAnnotationsDbUid() const { return mDefaultAnnotationsDbUid; }
    inline QVariant nameUI() const { return mNameUI; }
    inline QVariant statusUI() const { return mStatusUI; }
    inline QVariant sourceUI() const { return mSourceUI; }
    inline bool isIndex() const { return mIsIndex; }
    inline QString sex() const { return mSex; }
    inline QJsonObject stats() const { return mStats; }

    // Setters
    inline void setName(QString name) { mName = name; emit dataChanged(); }
    inline void setNickname(QString nickname) { mNickname = nickname; emit dataChanged(); }
    inline void setIsMosaic(bool flag) { mIsMosaic = flag; emit dataChanged(); }
    inline void setComment(QString comment) { mComment = comment; emit dataChanged(); }
    inline void setSource(File* source) { mSource = source; emit dataChanged(); }
    inline void setStatus(SampleStatus status) { mStatus = status; emit dataChanged(); }
    inline void setSubject(Subject* subject) { mSubject = subject; emit dataChanged(); }
    inline void setReference(Reference* reference) { mReference = reference; emit dataChanged(); }
    inline void setLoadingProgress(double progress) { mLoadingProgress = progress; emit dataChanged(); }
    void setStatus(QString status);
    inline void setNameUI(QVariant data) { mNameUI = data; emit dataChanged(); }
    inline void setStatusUI(QVariant data) { mStatusUI = data; emit dataChanged(); }
    inline void setSourceUI(QVariant data) { mSourceUI = data; emit dataChanged(); }
    inline void setIsIndex(bool flag) { mIsIndex = flag; emit dataChanged(); }
    inline void setSex(QString sex) { mSex = sex; emit dataChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save subject information onto server
    Q_INVOKABLE void save() override;
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;
    //! Convert sample status into a string value
    QString statusToLabel(SampleStatus status, double progress);

    void refreshUIAttributes();


public Q_SLOTS:
    void updateSearchField() override;
    void propagateDataChanged();

private:
    int mId = -1;
    QString mName;
    QString mNickname;
    bool mIsMosaic = false;
    QString mComment;
    QStringList mDefaultAnnotationsDbUid;
    File* mSource = nullptr;
    SampleStatus mStatus;
    Subject* mSubject = nullptr;
    Reference* mReference = nullptr;
    double mLoadingProgress = 0;
    QJsonObject mStats;


    // QML shortcuts
    QVariant mNameUI;
    QVariant mStatusUI;
    QVariant mSourceUI;
    bool mIsIndex = false;
    QString mSex;
};

#endif // SAMPLE_H
