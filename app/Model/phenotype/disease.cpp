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

bool Disease::fromJson(QJsonObject json)
{
    mId = json["id"].toString();
    mLabel = json["label"].toString();
    mDiseasesFreq = 0;

    if (mLoaded || !json.contains("definition"))
    {
        mLoaded = false;
        emit dataChanged();
        return true;
    }

    // Load full data
    // Todo
    emit dataChanged();
    return true;
}
