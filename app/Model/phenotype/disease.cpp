#include "disease.h"


Disease::Disease(QObject* parent) : HpoData(parent)
{
    mType = "disease";
    connect(this, &Disease::dataChanged, this, &Disease::updateSearchField);
}

Disease::Disease(QString hpoId, QObject* parent) : Disease(parent)
{
    mId = hpoId;
}


void Disease::updateSearchField()
{
    mSearchField = mId + " " + mLabel;
    // TODO: add genes, diseases label
}

bool Disease::loadJson(QJsonObject json)
{
    mId = json["id"].toString();
    mLabel = json["label"].toString();

    if (mLoaded)
    {
        emit dataChanged();
        return true;
    }

    if (json.contains("genes"))
    {
        mGenes->clear();
        for(const QJsonValue& val: json["genes"].toArray())
        {
            mGenes->append(val.toString());
        }
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

    emit dataChanged();
    return true;
}
