#ifndef SUBJECT_H
#define SUBJECT_H

#include <QtCore>
#include "Model/file/file.h"
#include "Model/phenotype/phenotype.h"
#include "Model/phenotype/phenotypeslistmodel.h"

class Sample;
class EventsListModel;
class PhenotypesListModel;

class Subject : public QObject
{
    Q_OBJECT
    // Regovar resource attribute
    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QDateTime updateDate READ updateDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createDate READ createDate NOTIFY dataChanged)
    // Subject attributes
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString identifier READ identifier WRITE setIdentifier NOTIFY dataChanged)
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY dataChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(Sex sex READ sex WRITE setSex NOTIFY dataChanged)
    Q_PROPERTY(QDate dateOfBirth READ dateOfBirth WRITE setDateOfBirth NOTIFY dataChanged)
    Q_PROPERTY(QString familyNumber READ familyNumber WRITE setFamilyNumber NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> samples READ samples NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> analyses READ analyses NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> projects READ projects NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> jobs READ jobs NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> files READ files NOTIFY dataChanged)
    Q_PROPERTY(QList<QObject*> indicators READ indicators NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* phenotypes READ phenotypes NOTIFY dataChanged)
    Q_PROPERTY(EventsListModel* events READ events NOTIFY dataChanged)
    // Special "shortcut" properties for qml display
    Q_PROPERTY(QJsonObject subjectUI READ subjectUI NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

public:
    enum Sex
    {
        Unknow=0,
        Female,
        Male,
    };
    Q_ENUM(Sex)

    // Constructors
    explicit Subject(QObject* parent = nullptr);
    explicit Subject(int id, QObject* parent = nullptr);
    explicit Subject(QJsonObject json, QObject* parent = nullptr);

    // Getters
    inline bool loaded() const { return mLoaded; }
    inline QDateTime updateDate() const { return mUpdateDate; }
    inline QDateTime createDate() const { return mCreateDate; }
    inline int id() const { return mId; }
    inline QString identifier() const { return mIdentifier; }
    inline QString firstname() const { return mFirstname; }
    inline QString lastname() const { return mLastname; }
    inline QString comment() const { return mComment; }
    inline QString familyNumber() const { return mFamilyNumber; }
    inline Sex sex() const { return mSex; }
    inline QDate dateOfBirth() const { return mDateOfBirth; }
    inline QList<QObject*> samples() const { return mSamples; }
    inline QList<QObject*> analyses() const { return mAnalyses; }
    inline QList<QObject*> projects() const { return mProjects; }
    inline QList<QObject*> jobs() const { return mJobs; }
    inline QList<QObject*> files() const { return mFiles; }
    inline QList<QObject*> indicators() const { return mIndicators; }
    inline PhenotypesListModel* phenotypes() const { return mPhenotypes; }
    inline EventsListModel* events() const { return mEvents; }
    inline QJsonObject subjectUI() const { return mSubjectUI; }
    inline QString searchField() const { return mSearchField; }

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
    Q_INVOKABLE bool fromJson(QJsonObject json, bool full_init=true);
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson();
    //! Save subject information onto server
    Q_INVOKABLE void save();
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true);
    //! Associate a sample to the subject
    Q_INVOKABLE void addSample(Sample* sample);
    //! Remove the association between the sample and the subject
    Q_INVOKABLE void removeSample(Sample* sample);
    //! Associate a phenotype/disease to the subject
    Q_INVOKABLE void addHpo(HpoData* hpo, QString presence="present");
    //! Remove the association between the phenotype/disease and the subject
    Q_INVOKABLE void removeHpo(HpoData* hpo);
    //! SubjectUI is a all-in-one property to quickly display subject in the UI.
    void updateSubjectUI();
    QString computeAge(QDate d1, QDate d2);
    Q_INVOKABLE QString presence(QString hpoId) const;
    Q_INVOKABLE void setPresence(QString hpoId, QString presence);
    Q_INVOKABLE QDateTime additionDate(QString hpoId) const;

Q_SIGNALS:
    void dataChanged();

public Q_SLOTS:
    void updateSearchField();

private:
    bool mLoaded = false;
    QDateTime mUpdateDate;
    QDateTime mCreateDate;
    QDateTime mLastInternalLoad = QDateTime::currentDateTime();

    int mId = -1;
    QString mIdentifier = "";
    QString mFirstname = "";
    QString mLastname = "";
    QString mComment = "";
    QString mFamilyNumber = "";
    Sex mSex = Sex::Unknow;
    QDate mDateOfBirth;
    QList<QObject*> mSamples;
    QList<QObject*> mAnalyses;
    QList<QObject*> mProjects;
    QList<QObject*> mJobs;
    QList<QObject*> mFiles;
    QList<QObject*> mIndicators;
    PhenotypesListModel* mPhenotypes = nullptr;
    EventsListModel* mEvents = nullptr;
    QJsonObject mSubjectUI;
    QString mSearchField = "";
    QHash<QString, QString> mPresence;
    QHash<QString, QDateTime> mAdditionDate;
};

#endif // SUBJECT_H
