#include "savedfilter.h"

SavedFilter::SavedFilter(QObject* parent) : QObject(parent)
{

}
SavedFilter::SavedFilter(QJsonObject json, QObject* parent): QObject(parent)
{
    fromJson(json);
}


void SavedFilter::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mFilter = json["filter"].toArray();
    mCount = json["total_variants"].toInt();
    mProgress = 1;
    emit dataChanged();
}
