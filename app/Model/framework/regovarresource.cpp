#include "regovarresource.h"

RegovarResource::RegovarResource(QObject* parent): QObject(parent)
{
}


void RegovarResource::updateSearchField()
{
    qDebug() << "Warning: calling default implementation of RegovarResource::updateSearchField(). Nothing done.";
}

//! Set model with provided json data
bool RegovarResource::loadJson(const QJsonObject&, bool)
{
    qDebug() << "Warning: calling default implementation of RegovarResource::loadJson(QJsonObject). Nothing done.";
    return false;
}
//! Export model data into json object
QJsonObject RegovarResource::toJson()
{
    qDebug() << "Warning: calling default implementation of RegovarResource::toJson(). Nothing done.";
    return QJsonObject();
}
//! Save resource information onto server
void RegovarResource::save()
{
    qDebug() << "Warning: calling default implementation of RegovarResource::save(). Nothing done.";
}
//! Load resource information from server
void RegovarResource::load(bool)
{
    qDebug() << "Warning: calling default implementation of RegovarResource::load(bool). Nothing done.";
}
