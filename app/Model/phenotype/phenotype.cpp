#include "phenotype.h"

Phenotype::Phenotype(QObject *parent) : QObject(parent)
{

}


void Phenotype::fromJson(QJsonObject json)
{
    mId = json["id"].toString();
    mLabel = json["label"].toString();
}
