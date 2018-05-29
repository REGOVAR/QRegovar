#ifndef SUBJECT_H
#define SUBJECT_H

#include <QtCore>
#include "Model/framework/regovarresource.h"
#include "Model/file/file.h"
#include "Model/analysis/analyseslistmodel.h"
#include "Model/file/fileslistmodel.h"
#include "sampleslistmodel.h"

class Sample;
class EventsListModel;
class HpoData;
class HpoDataListModel;
class SamplesListModel;
class Subject : public RegovarResource
{
    Q_OBJECT
    // Subject attributes
    Q_PROPERTY(int id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString identifier READ identifier WRITE setIdentifier NOTIFY dataChanged)
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY dataChanged)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY dataChanged)
    Q_PROPERTY(Sex sex READ sex WRITE setSex NOTIFY dataChanged)
    Q_PROPERTY(QDate dateOfBirth READ dateOfBirth WRITE setDateOfBirth NOTIFY dataChanged)
    Q_PROPERTY(QString familyNumber READ familyNumber WRITE setFamilyNumber NOTIFY dataChanged)
    Q_PROPERTY(SamplesListModel* samples READ samples NOTIFY dataChanged)
    Q_PROPERTY(AnalysesListModel* analyses READ analyses NOTIFY dataChanged)
    Q_PROPERTY(FilesListModel* files READ files NOTIFY dataChanged)
    // TODO: Q_PROPERTY(XXX indicators READ indicators NOTIFY dataChanged)
    Q_PROPERTY(HpoDataListModel* phenotypes READ phenotypes NOTIFY dataChanged)
    Q_PROPERTY(EventsListModel* events READ events NOTIFY dataChanged)
    // Special "shortcut" properties for qml display
    Q_PROPERTY(QJsonObject subjectUI READ subjectUI NOTIFY dataChanged)

public:
    enum Sex
    {
        Unknow=0,
        Female,
        Male,
    };
    Q_ENUM(Sex)

    // Constructors
    Subject(QObject* parent = nullptr);
    Subject(int id, QObject* parent = nullptr);
    Subject(QJsonObject json, QObject* parent = nullptr);

    // Getters
    inline int id() const { return mId; }
    inline QString identifier() const { return mIdentifier; }
    inline QString firstname() const { return mFirstname; }
    inline QString lastname() const { return mLastname; }
    inline QString comment() const { return mComment; }
    inline QString familyNumber() const { return mFamilyNumber; }
    inline Sex sex() const { return mSex; }
    inline QDate dateOfBirth() const { return mDateOfBirth; }
    inline SamplesListModel* samples() const { return mSamples; }
    inline AnalysesListModel* analyses() const { return mAnalyses; }
    inline FilesListModel* files() const { return mFiles; }
    inline HpoDataListModel* phenotypes() const { return mPhenotypes; }
    inline EventsListModel* events() const { return mEvents; }
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
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Export model data into json object
    Q_INVOKABLE QJsonObject toJson() override;
    //! Save subject information onto server
    Q_INVOKABLE void save() override;
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;
    //! Associate a sample to the subject
    Q_INVOKABLE void addSample(Sample* sample);
    //! Remove the association between the sample and the subject
    Q_INVOKABLE void removeSample(Sample* sample);
    //! Associate a phenotype/disease to the subject
    Q_INVOKABLE void setHpo(HpoData* hpo, QString presence="present");
    //! Remove the association between the phenotype/disease and the subject
    Q_INVOKABLE void removeHpo(HpoData* hpo);
    //! SubjectUI is a all-in-one property to quickly display subject in the UI.
    void updateSubjectUI();
    QString computeAge(QDate d1, QDate d2);
    Q_INVOKABLE QString presence(QString hpoId) const;
    Q_INVOKABLE QDateTime additionDate(QString hpoId) const;


public Q_SLOTS:
    void updateSearchField() override;
    void saveFile(int fileId);

private:
    int mId = -1;
    QString mIdentifier = "";
    QString mFirstname = "";
    QString mLastname = "";
    QString mComment = "";
    QString mFamilyNumber = "";
    Sex mSex = Sex::Unknow;
    QDate mDateOfBirth;
    SamplesListModel* mSamples = nullptr;
    AnalysesListModel* mAnalyses = nullptr;
    FilesListModel* mFiles = nullptr;
    HpoDataListModel* mPhenotypes = nullptr;
    EventsListModel* mEvents = nullptr;
    QJsonObject mSubjectUI;
    QHash<QString, QString> mPresence;
    QHash<QString, QDateTime> mAdditionDate;
};

#endif // SUBJECT_H
