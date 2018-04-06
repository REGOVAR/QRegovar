#include "disease.h"


Disease::Disease(QObject* parent) : QObject(parent)
{
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

void Disease::fromJson(QJsonObject json)
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
    // Todo
    emit dataChanged();
}
