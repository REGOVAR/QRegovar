#include "phenotype.h"
#include "Model/regovar.h"


Phenotype::Phenotype(QObject *parent) : QObject(parent)
{
    mParents = new PhenotypesListModel(this);
    mChilds = new PhenotypesListModel(this);
    connect(this, &Phenotype::dataChanged, this, &Phenotype::updateSearchField);
}
Phenotype::Phenotype(QString hpo_id, QObject *parent) : Phenotype(parent)
{
    mId = hpo_id;
}


void Phenotype::updateSearchField()
{
    mSearchField = mId + " " + mLabel + " " + mDefinition;
    // TODO: add genes, diseases label
}

void Phenotype::fromJson(QJsonObject json)
{
    mId = json["id"].toString();
    mLabel = json["label"].toString();

    if (mLoaded || !json.contains("definition"))
    {
        mLoaded = false;
        emit dataChanged();
        return;
    }

    // Load full data
    mDefinition = json["definition"].toString();
    mParents->clear();
    mChilds->clear();
    for(const QJsonValue& val: json["parents"].toArray())
    {
        QJsonObject parent = val.toObject();
        Phenotype* ppheno = regovar->phenotypesManager()->getOrCreatePhenotype(parent["id"].toString());
        ppheno->fromJson(parent);
        mChilds->add(ppheno);
    }
    for(const QJsonValue& val: json["childs"].toArray())
    {
        QJsonObject child = val.toObject();
        Phenotype* cpheno = regovar->phenotypesManager()->getOrCreatePhenotype(child["id"].toString());
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
        Disease* dise = regovar->phenotypesManager()->getOrCreateDisease(jdise["id"].toString());
        dise->fromJson(jdise);
        mDiseases.append(dise);
    }
    emit dataChanged();
}


QString Phenotype::presence(int subjectId) const
{
    if (mPresence.contains(subjectId))
        return mPresence[subjectId];
    return "unknow";
}
void Phenotype::setPresence(int subjectId, QString presence)
{
    mPresence[subjectId] = presence;
}
