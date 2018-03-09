#include "phenotypesmanager.h"

PhenotypesManager::PhenotypesManager(QObject *parent) : QObject(parent)
{

}



void PhenotypesManager::fromJson(QJsonArray json)
{
    for (const QJsonValue& data: json)
    {
        QJsonObject item = data.toObject();
        if (!mPhenotypes.contains(item["id"].toString()))
        {

        }
    }
}

QStringList PhenotypesManager::search(QString query)
{

}
