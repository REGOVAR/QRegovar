#include "phenotype.h"
#include "Model/regovar.h"


Phenotype::Phenotype(QObject* parent) : HpoData(parent)
{
    mType = "phenotype";
    mParents = new PhenotypesListModel(this);
    mChilds = new PhenotypesListModel(this);
    connect(this, &Phenotype::dataChanged, this, &Phenotype::updateSearchField);
}
Phenotype::Phenotype(QString hpo_id, QObject* parent) : Phenotype( parent)
{
    mId = hpo_id;
}


void Phenotype::updateSearchField()
{
    mSearchField = mId + " " + mLabel + " " + mDefinition;
    // TODO: add genes, diseases label
}

bool Phenotype::fromJson(QJsonObject json)
{
    mId = json["id"].toString();
    mLabel = json["label"].toString();

    if (mLoaded || !json.contains("definition"))
    {
        mLoaded = false;
        emit dataChanged();
        return true;
    }

    // Load full data
    mDefinition = json["definition"].toString();
    mParents->clear();
    mChilds->clear();
    for(const QJsonValue& val: json["parents"].toArray())
    {
        QJsonObject parent = val.toObject();
        Phenotype* ppheno = (Phenotype*) regovar->phenotypesManager()->getOrCreate(parent["id"].toString());
        ppheno->fromJson(parent);
        mChilds->add(ppheno);
    }
    for(const QJsonValue& val: json["childs"].toArray())
    {
        QJsonObject child = val.toObject();
        Phenotype* cpheno = (Phenotype*) regovar->phenotypesManager()->getOrCreate(child["id"].toString());
        cpheno->fromJson(child);
        mChilds->add(cpheno);
    }
    for(const QJsonValue& val: json["genes"].toArray())
    {
        mGenes.append(val.toString());
    }
    for(const QJsonValue& val: json["diseases"].toArray())
    {
        QJsonObject jdise = val.toObject();
        Disease* dise = (Disease*) regovar->phenotypesManager()->getOrCreate(jdise["id"].toString());
        dise->fromJson(jdise);
        mDiseases.append(dise);
    }
    emit dataChanged();
    return true;
}

