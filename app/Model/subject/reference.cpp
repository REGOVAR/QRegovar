#include "reference.h"


Reference::Reference(QObject* parent) : QObject(parent)
{
}


bool Reference::loadJson(QJsonObject json)
{
    mId = json["id"].toInt();
    setName(json["name"].toString());
    return true;
}
