#include "filter.h"

Filter::Filter(QObject* parent) : QObject(parent)
{
}

Filter::Filter(int id, QString name, QString description, QString qFilter, QString filter, int count, QObject* parent): QObject(parent)
{
    mId = id;
    mName = name;
    mDescription = description;
    mQFilter = qFilter;
    mFilter = filter;
    mCount = count;
}


bool Filter::fromJson(QJsonObject json)
{
    // load basic data from json
    // TODO
    mId = json["id"].toInt();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mQFilter = "TODO";
    mCount = json["total_variants"].toInt();

    // Retrieve filter
    QJsonDocument doc;
    doc.setArray(json["filter"].toArray());
    mFilter = QString(doc.toJson(QJsonDocument::Indented));
}
