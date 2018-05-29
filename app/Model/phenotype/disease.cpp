#include "disease.h"


Disease::Disease(QObject* parent) : HpoData(parent)
{
    mPhenotypes = new PhenotypesListModel(this);
    mType = "disease";
    connect(this, &Disease::dataChanged, this, &Disease::updateSearchField);
}

Disease::Disease(QString hpoId, QObject* parent) : Disease(parent)
{
    mId = hpoId;
    mPhenotypes->setDiseaseId(mId);
}


void Disease::updateSearchField()
{
    mSearchField = mId + " " + mLabel;
    // TODO: add genes, diseases label
}

bool Disease::loadJson(QJsonObject json, bool)
{
    mId = json["id"].toString();
    mPhenotypes->setDiseaseId(mId);
    mLabel = json["label"].toString();

    if (mLoaded)
    {
        emit dataChanged();
        return true;
    }

    if (json.contains("genes"))
    {
        mGenes->loadJson(json["genes"].toArray());
    }
    if (json.contains("meta"))
    {
        QJsonObject meta = json["meta"].toObject();
        mGenesFreq = meta["genes_freq"].toObject();
        if (meta.contains("sources"))
        {
            mSources.clear();
            for(const QJsonValue& val: meta["sources"].toArray())
            {
                mSources.append(val.toString());
            }
        }
    }
    if (json.contains("omim"))
    {
        mOmim = json["omim"].toObject();
        mLoaded = true;
    }
    if (json.contains("orpha"))
    {
        mOrpha = json["orpha"].toObject();
        mLoaded = true;
    }
    if (json.contains("decipher"))
    {
        mDecipher = json["decipher"].toObject();
        mLoaded = true;
    }
    if (json.contains("phenotypes"))
    {
        mPhenotypes->loadJson(json["phenotypes"].toArray());
    }
    if (json.contains("subjects"))
    {
        mSubjects->loadJson(json["subjects"].toArray());
    }

    emit dataChanged();
    return true;
}
