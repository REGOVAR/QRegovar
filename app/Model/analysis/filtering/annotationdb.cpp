#include "annotationdb.h"

AnnotationDB::AnnotationDB(QObject* parent) : QObject(parent)
{
}


bool AnnotationDB::fromJson(QJsonObject json)
{
    mUid = json["id"].toInt();
    mName = json["name"].toString();
    mName = json["name"].toString();
    mName = json["name"].toString();
    return true;
}

