#ifndef PHENOTYPE_H
#define PHENOTYPE_H

#include <QtCore>
#include "hpodata.h"
#include "disease.h"
#include "hpodatalistmodel.h"
#include "diseaseslistmodel.h"

class Disease;
class HpoData;
class HpoDataListModel;
class DiseasesListModel;
class Phenotype : public HpoData
{
    Q_OBJECT
    Q_PROPERTY(QString definition READ definition NOTIFY dataChanged)
    Q_PROPERTY(HpoDataListModel* parents READ parents NOTIFY dataChanged)
    Q_PROPERTY(HpoDataListModel* childs READ childs NOTIFY dataChanged)
    Q_PROPERTY(DiseasesListModel* diseases READ diseases NOTIFY dataChanged)



public:
    // Constructor
    Phenotype(QObject* parent = nullptr);
    Phenotype(QString hpo_id, QObject* parent = nullptr);

    // Getters
    inline QString definition() const { return mDefinition; }
    inline HpoDataListModel* parents() const { return mParents; }
    inline HpoDataListModel* childs() const { return mChilds; }
    inline DiseasesListModel* diseases() const { return mDiseases; }

    // Methods
    //! Set model with provided json data
    Q_INVOKABLE bool loadJson(QJsonObject json, bool full_init=true) override;
    //! Return the phenotype qualifiers (as human readable string) for the requested disease
    Q_INVOKABLE QString qualifier(QString diseaseId) const;


public Q_SLOTS:
    void updateSearchField() override;


private:
    QString mDefinition;
    HpoDataListModel* mParents = nullptr;
    HpoDataListModel* mChilds = nullptr;
    DiseasesListModel* mDiseases = nullptr;
    QJsonObject mQualifiers;
};

#endif // PHENOTYPE_H
