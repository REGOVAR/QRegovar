#ifndef HPODATA_H
#define HPODATA_H

#include <QtCore>
#include "Model/framework/regovarresource.h"

class SubjectsListModel;
class GenesListModel;
class HpoData: public RegovarResource
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

public:
    // Constructor
    HpoData(QObject* parent = nullptr);

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

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(const QJsonObject& json, bool full_init=true) override;
    //! Load Subject information from server
    Q_INVOKABLE void load(bool forceRefresh=true) override;



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
};

#endif // HPODATA_H
