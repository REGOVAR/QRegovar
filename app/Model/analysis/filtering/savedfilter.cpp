#include "savedfilter.h"

SavedFilter::SavedFilter(QObject* parent) : QObject(parent)
{
    mId = -1;
    mCount = 0;
    mProgress =  0;
}
SavedFilter::SavedFilter(QJsonObject json, QObject* parent): QObject(parent)
{
    loadJson(json);
}


bool SavedFilter::loadJson(const QJsonObject &json)
{
    mId = json["id"].toInt();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mFilter = json["filter"].toArray();
    mCount = json["total_variants"].toInt();
    mProgress =  json["progress"].toDouble();
    emit dataChanged();
    return true;
}
