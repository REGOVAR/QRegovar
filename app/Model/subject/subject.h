#ifndef SUBJECT_H
#define SUBJECT_H

#include <QtCore>
#include "Model/file/file.h"

class Sample;

class Subject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString identifier READ identifier WRITE setIdentifier NOTIFY dataChanged)
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY dataChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(Sex sex READ sex WRITE setSex NOTIFY dataChanged)
    Q_PROPERTY(QDate dateOfBirth READ dateOfBirth WRITE setDateOfBirth NOTIFY dataChanged)
    Q_PROPERTY(QString familyNumber READ familyNumber WRITE setFamilyNumber NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updated READ updated NOTIFY dataChanged)
    Q_PROPERTY(QDateTime created READ created NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> samples READ samples NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> analyses READ analyses NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> projects READ projects NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> jobs READ jobs NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> files READ files NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> indicators READ indicators NOTIFY dataChanged)
    // Special "shortcut" properties for qml display
    Q_PROPERTY(QJsonObject subjectUI READ subjectUI NOTIFY dataChanged)

public:
    enum Sex
    {
        Unknow=0,
        Male,
        Female,
    };
    Q_ENUM(Sex)

    // Constructors
    explicit Subject(QObject *parent = nullptr);
    explicit Subject(int id, QObject *parent = nullptr);
    explicit Subject(QJsonObject json, QObject *parent = nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString identifier() const { return mIdentifier; }
    inline QString firstname() const { return mFirstname; }
    inline QString lastname() const { return mLastname; }
    inline QString comment() const { return mComment; }
    inline QString familyNumber() const { return mFamilyNumber; }
    inline Sex sex() const { return mSex; }
    inline QDate dateOfBirth() const { return mDateOfBirth; }
    inline QDateTime updated() const { return mUpdated; }
    inline QDateTime created() const { return mCreated; }
    inline QList<QObject*> samples() const { return mSamples; }
    inline QList<QObject*> analyses() const { return mAnalyses; }
    inline QList<QObject*> projects() const { return mProjects; }
    inline QList<QObject*> jobs() const { return mJobs; }
    inline QList<QObject*> files() const { return mFiles; }
    inline QList<QObject*> indicators() const { return mIndicators; }
    inline QJsonObject subjectUI() const { return mSubjectUI; }

    // Setters
    inline void setIdentifier(QString val) { mIdentifier = val; updateSubjectUI(); emit dataChanged(); }
    inline void setFirstname(QString val) { mFirstname = val; updateSubjectUI(); emit dataChanged(); }
    inline void setLastname(QString val) { mLastname = val; updateSubjectUI(); emit dataChanged(); }
    inline void setComment(QString val) { mComment = val; emit dataChanged(); }
    inline void setFamilyNumber(QString val) { mFamilyNumber = val; emit dataChanged(); }
    inline void setSex(Sex val) { mSex = val; updateSubjectUI(); emit dataChanged(); }
    inline void setDateOfBirth(QDate val) { mDateOfBirth = val; updateSubjectUI(); emit dataChanged(); }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool fromJson(QJsonObject json);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load();
    //! Associate a sample to the subject
    Q_INVOKABLE void addSample(Sample* sample);
    //! SubjectUI is a all-in-one property to quickly display subject in the UI.
    void updateSubjectUI();
    QString computeAge(QDate d1, QDate d2);

Q_SIGNALS:
    void dataChanged();


private:
    int mId;
    QString mIdentifier;
    QString mFirstname;
    QString mLastname;
    QString mComment;
    QString mFamilyNumber;
    Sex mSex;
    QDate mDateOfBirth;
    QDateTime mUpdated;
    QDateTime mCreated;
    QList<QObject*> mSamples;
    QList<QObject*> mAnalyses;
    QList<QObject*> mProjects;
    QList<QObject*> mJobs;
    QList<QObject*> mFiles;
    QList<QObject*> mIndicators;
    QJsonObject mSubjectUI;
};

#endif // SUBJECT_H
