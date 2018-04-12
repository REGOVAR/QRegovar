#ifndef PHENOTYPE_H
#define PHENOTYPE_H

#include <QtCore>
#include "hpodata.h"
#include "disease.h"
#include "phenotypeslistmodel.h"

class Disease;
class PhenotypesListModel;
class Phenotype : public HpoData
{
    Q_OBJECT
    Q_PROPERTY(QString definition READ definition NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* parents READ parents NOTIFY dataChanged)
    Q_PROPERTY(PhenotypesListModel* childs READ childs NOTIFY dataChanged)
    Q_PROPERTY(QList<Disease*> diseases READ diseases NOTIFY dataChanged)


public:
    // Constructor
    explicit Phenotype(QObject* parent = nullptr);
    explicit Phenotype(QString hpo_id, QObject* parent = nullptr);

    // Getters
    inline QString definition() const { return mDefinition; }
    inline PhenotypesListModel* parents() const { return mParents; }
    inline PhenotypesListModel* childs() const { return mChilds; }
    inline QList<Disease*> diseases() const { return mDiseases; }

    // HpoData  abstracts methods overriden
    Q_INVOKABLE bool fromJson(QJsonObject json);


public Q_SLOTS:
    virtual void updateSearchField();


private:
    QString mDefinition;
    PhenotypesListModel* mParents = nullptr;
    PhenotypesListModel* mChilds = nullptr;
    QList<Disease*> mDiseases;
};

#endif // PHENOTYPE_H
