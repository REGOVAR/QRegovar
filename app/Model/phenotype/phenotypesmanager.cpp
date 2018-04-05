#include "phenotypesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

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

void PhenotypesManager::search(QString query)
{
    QJsonObject json;
    json.insert("search", query);
    Request* req = Request::post(QString("/phenotypes/search"), QJsonDocument(json).toJson());
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            emit phenotypeSearchDone(true, json["data"].toArray());
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
            emit phenotypeSearchDone(false, QJsonArray());
        }
        req->deleteLater();
    });
}
