#ifndef SUBJECT_H
#define SUBJECT_H

#include <QtCore>
#include "Model/file/file.h"

class Subject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString identifier READ identifier WRITE setIdentifier NOTIFY dataChanged)
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY dataChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(Sex sex READ sex WRITE setSex NOTIFY dataChanged)
    Q_PROPERTY(QDateTime dateOfBirth READ dateOfBirth WRITE setDateOfBirth NOTIFY dataChanged)
    Q_PROPERTY(QDateTime dateOfDeath READ dateOfDeath WRITE setDateOfDeath NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updated READ updated NOTIFY dataChanged)
    Q_PROPERTY(QDateTime created READ created NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> samples READ samples NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> analyses READ analyses NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> projects READ projects NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> jobs READ jobs NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> files READ files NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> indicators READ indicators NOTIFY dataChanged)
    // special "shortcut" property for qml tableView

public:
    enum Sex
    {
        Unknow=0,
        Male,
        Female,
    };

    // Constructors
    explicit Subject(QObject *parent = nullptr);
    explicit Subject(QJsonObject json, QObject *parent = nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString identifier() const { return mIdentifier; }
    inline QString firstname() const { return mFirstname; }
    inline QString lastname() const { return mLastname; }
    inline QString comment() const { return mComment; }
    inline Sex sex() const { return mSex; }
    inline QDateTime dateOfBirth() const { return mDateOfBirth; }
    inline QDateTime dateOfDeath() const { return mDateOfDeath; }
    inline QDateTime updated() const { return mUpdated; }
    inline QDateTime created() const { return mCreated; }
    inline QList<QObject*> samples() const { return mSamples; }
    inline QList<QObject*> analyses() const { return mAnalyses; }
    inline QList<QObject*> projects() const { return mProjects; }
    inline QList<QObject*> jobs() const { return mJobs; }
    inline QList<QObject*> files() const { return mFiles; }
    inline QList<QObject*> indicators() const { return mIndicators; }

    // Setters
    inline void setIdentifier(QString val) { mIdentifier = val; emit dataChanged(); }
    inline void setFirstname(QString val) { mFirstname = val; emit dataChanged(); }
    inline void setLastname(QString val) { mLastname = val; emit dataChanged(); }
    inline void setComment(QString val) { mComment = val; emit dataChanged(); }
    inline void setSex(Sex val) { mSex = val; emit dataChanged(); }
    inline void setDateOfBirth(QDateTime val) { mDateOfBirth = val; emit dataChanged(); }
    inline void setDateOfDeath(QDateTime val) { mDateOfDeath = val; emit dataChanged(); }

    // Methods
    Q_INVOKABLE bool fromJson(QJsonObject json);
    QJsonObject toJson();

Q_SIGNALS:
        void dataChanged();


private:
    int mId;
    QString mIdentifier;
    QString mFirstname;
    QString mLastname;
    QString mComment;
    Sex mSex;
    QDateTime mDateOfBirth;
    QDateTime mDateOfDeath;
    QDateTime mUpdated;
    QDateTime mCreated;
    QList<QObject*> mSamples;
    QList<QObject*> mAnalyses;
    QList<QObject*> mProjects;
    QList<QObject*> mJobs;
    QList<QObject*> mFiles;
    QList<QObject*> mIndicators;

};

#endif // SUBJECT_H
