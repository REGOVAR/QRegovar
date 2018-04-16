#include "hpodata.h"



HpoData::HpoData(QObject* parent) : QObject(parent)
{
    mGenes = new GenesListModel(this);
    mSubjects = new SubjectsListModel(this);
}


bool HpoData::loadJson(QJsonObject)
{
    return false;
}
