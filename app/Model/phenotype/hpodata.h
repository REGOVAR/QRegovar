#ifndef HPODATA_H
#define HPODATA_H

#include <QtCore>
#include "geneslistmodel.h"
#include "Model/subject/subjectslistmodel.h"

class SubjectsListModel;
class HpoData: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(QString type READ type  NOTIFY dataChanged)
    Q_PROPERTY(QStringList sources READ sources NOTIFY dataChanged)
    Q_PROPERTY(GenesListModel* genes READ genes NOTIFY dataChanged)
    Q_PROPERTY(SubjectsListModel* subjects READ subjects NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject genesFreq READ genesFreq NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject diseasesFreq READ diseasesFreq NOTIFY dataChanged)
    Q_PROPERTY(QString category READ category NOTIFY dataChanged)
    Q_PROPERTY(QJsonObject meta READ meta NOTIFY dataChanged)

    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

public:
    // Constructor
    explicit HpoData(QObject* parent = nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString label() const { return mLabel; }
    inline QString type() const { return mType; }
    inline QStringList sources() const { return mSources; }
    inline GenesListModel* genes() const { return mGenes; }
    inline SubjectsListModel* subjects() const { return mSubjects; }
    inline QJsonObject genesFreq() const { return mGenesFreq; }
    inline QJsonObject diseasesFreq() const { return mDiseasesFreq; }
    inline QString category() const { return mCategory; }
    inline QJsonObject meta() const { return mMeta; }
    inline bool loaded() const { return mLoaded; }
    inline QString searchField() const { return mSearchField; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE virtual bool loadJson(QJsonObject json);


Q_SIGNALS:
    void dataChanged();


protected:
    QString mId;
    QString mLabel;
    QString mType;
    QStringList mSources;
    GenesListModel* mGenes = nullptr;
    SubjectsListModel* mSubjects = nullptr;
    QString mCategory;
    QJsonObject mGenesFreq;
    QJsonObject mDiseasesFreq;
    QJsonObject mMeta;
    bool mLoaded = false;
    QString mSearchField;
};

#endif // HPODATA_H
