#include "hpodata.h"



HpoData::HpoData(QObject* parent) : QObject(parent)
{
    mGenes = new GenesListModel(this);
}


bool HpoData::fromJson(QJsonObject)
{
    return false;
}
