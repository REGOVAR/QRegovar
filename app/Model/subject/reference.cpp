#include "reference.h"


Reference::Reference(QObject* parent) : QObject(parent)
{
}


bool Reference::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    setName(json["name"].toString());
    return true;
}
