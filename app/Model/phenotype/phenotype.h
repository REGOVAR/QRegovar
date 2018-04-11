#ifndef PHENOTYPE_H
#define PHENOTYPE_H

#include <QtCore>
#include "disease.h"
#include "phenotypeslistmodel.h"

class Disease;
class PhenotypesListModel;
class Phenotype : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString label READ label NOTIFY dataChanged)
    Q_PROPERTY(QString definition READ definition NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* parents READ parents NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* childs READ childs NOTIFY dataChanged)
    Q_PROPERTY(QStringList genes READ genes NOTIFY dataChanged)
    Q_PROPERTY(QList<Disease*> diseases READ diseases NOTIFY dataChanged)
    Q_PROPERTY(double genesScore READ genesScore NOTIFY dataChanged)
    Q_PROPERTY(double diseasesScore READ diseasesScore NOTIFY dataChanged)
    Q_PROPERTY(QString subontology READ subontology NOTIFY dataChanged)
    Q_PROPERTY(QStringList sources READ sources NOTIFY dataChanged)

    Q_PROPERTY(bool loaded READ loaded NOTIFY dataChanged)
    Q_PROPERTY(QString searchField READ searchField NOTIFY dataChanged)

public:
    // Constructor
    explicit Phenotype(QObject* parent = nullptr);
    explicit Phenotype(QString hpo_id, QObject* parent = nullptr);

    // Getters
    inline QString id() const { return mId; }
    inline QString label() const { return mLabel; }
    inline QString definition() const { return mDefinition; }
    inline PhenotypesListModel* parents() const { return mParents; }
    inline PhenotypesListModel* childs() const { return mChilds; }
    inline QStringList genes() const { return mGenes; }
    inline QList<Disease*> diseases() const { return mDiseases; }
    inline double genesScore() const { return mGenesScore; }
    inline double diseasesScore() const { return mDiseasesScore; }
    inline QString subontology() const { return mSubontology; }
    inline QStringList sources() const { return mSources; }
    inline bool loaded() const { return mLoaded; }
    inline QString searchField() const { return mSearchField; }

    // Methods
    void fromJson(QJsonObject json);
    Q_INVOKABLE QString presence(int subjectId) const;
    Q_INVOKABLE void setPresence(int subjectId, QString presence);



Q_SIGNALS:
    void dataChanged();


public Q_SLOTS:
    void updateSearchField();


private:
    QString mId;
    QString mLabel;
    QString mDefinition;
    QStringList mGenes;
    PhenotypesListModel* mParents = nullptr;
    PhenotypesListModel* mChilds = nullptr;
    QList<Disease*> mDiseases;
    double mGenesScore;
    double mDiseasesScore;
    QString mSubontology;
    QStringList mSources;
    QHash<int, QString> mPresence;
    bool mLoaded = false;
    QString mSearchField;
};

#endif // PHENOTYPE_H
