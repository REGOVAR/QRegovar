#include "phenotypesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

PhenotypesManager::PhenotypesManager(QObject* parent) : QObject(parent)
{
    mSearchResults = new PhenotypesListModel(this);
}



Phenotype* PhenotypesManager::getOrCreatePhenotype(QString hpoId)
{
    if (mPhenotypes.contains(hpoId))
    {
        return mPhenotypes[hpoId];
    }
    Phenotype* newPheno = new Phenotype(hpoId, this);
    mPhenotypes.insert(hpoId, newPheno);
    return newPheno;
}


Disease* PhenotypesManager::getOrCreateDisease(QString hpoId)
{
    if (mDiseases.contains(hpoId))
    {
        return mDiseases[hpoId];
    }
    Disease* newDisea = new Disease(hpoId, this);
    mDiseases.insert(hpoId, newDisea);
    return newDisea;
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
            mSearchResults->clear();
            mSearchResults->fromJson(json["data"].toArray());
            emit searchDone(true);
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
            emit searchDone(false);
        }
        req->deleteLater();
    });
}
