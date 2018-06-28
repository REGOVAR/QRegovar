#include "phenotype.h"
#include "Model/regovar.h"
#include "Model/phenotype/geneslistmodel.h"


Phenotype::Phenotype(QObject* parent) : HpoData(parent)
{
    mType = "phenotypic";
    mParents = new HpoDataListModel(this);
    mChilds = new HpoDataListModel(this);
    mDiseases = new DiseasesListModel(this);
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

bool Phenotype::loadJson(const QJsonObject& json, bool)
{
    bool fullLoaded = false;
    mId = json["id"].toString();
    mLabel = json["label"].toString();

    if (!json.contains("definition"))
    {
        mDefinition = json["definition"].toString();
        fullLoaded = true;
    }
    if (!json.contains("category"))
    {
        mDefinition = json["category"].toString();
    }

    if (json.contains("parents"))
    {
        mParents->clear();
        mChilds->clear();
        for(const QJsonValue& val: json["parents"].toArray())
        {
            QJsonObject parent = val.toObject();
            Phenotype* ppheno = (Phenotype*) regovar->phenotypesManager()->getOrCreate(parent["id"].toString());
            ppheno->loadJson(parent);
            mChilds->append(ppheno);
        }
        for(const QJsonValue& val: json["childs"].toArray())
        {
            QJsonObject child = val.toObject();
            Phenotype* cpheno = (Phenotype*) regovar->phenotypesManager()->getOrCreate(child["id"].toString());
            cpheno->loadJson(child);
            mChilds->append(cpheno);
        }
    }

    if (json.contains("genes"))
    {
        mGenes->loadJson(json["genes"].toArray());
    }
    if (json.contains("diseases"))
    {
        mDiseases->setPhenotypeId(mId);
        mDiseases->loadJson(json["diseases"].toArray());
    }
    if (json.contains("subjects"))
    {
        mSubjects->loadJson(json["subjects"].toArray());
    }

    if (json.contains("meta"))
    {
        mMeta = json["meta"].toObject();
        if (mMeta.contains("genes_freq"))
        {
            mGenesFreq = mMeta["genes_freq"].toObject();
        }
        if (mMeta.contains("diseases_freq"))
        {
            mDiseasesFreq = mMeta["diseases_freq"].toObject();
        }
        if (mMeta.contains("qualifiers"))
        {
            mQualifiers = mMeta["qualifiers"].toObject();
        }
        if (mMeta.contains("sources"))
        {
            mSources.clear();
            for(const QJsonValue& val: mMeta["sources"].toArray())
            {
                mSources.append(val.toString());
            }
        }
    }

    mLoaded = mLoaded || fullLoaded;
    emit dataChanged();
    return true;
}



QString Phenotype::qualifier(QString diseaseId) const
{
    QString result;
    if (mQualifiers.contains(diseaseId))
    {
        for (const QJsonValue& val: mQualifiers[diseaseId].toArray() )
        {
            QJsonObject data = val.toObject();
            if (data.contains("definition"))
                result += data["definition"].toString() + " ";
            else
                result += val.toString() + ". ";
        }
    }
    return result;
}
