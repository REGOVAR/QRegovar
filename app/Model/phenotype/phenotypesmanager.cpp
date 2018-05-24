#include "phenotypesmanager.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

PhenotypesManager::PhenotypesManager(QObject* parent) : QObject(parent)
{
    mSearchResults = new HpoDataListModel(this);
}



HpoData* PhenotypesManager::getOrCreate(QString hpoId)
{
    if (mHpoData.contains(hpoId))
    {
        return mHpoData[hpoId];
    }
    HpoData* hpo = nullptr;
    if (hpoId.startsWith("HP:"))
    {
        hpo = new Phenotype(hpoId, this);
    }
    else
    {
        hpo = new Disease(hpoId, this);
    }
    mHpoData.insert(hpoId, hpo);
    return hpo;
}


Gene* PhenotypesManager::getGene(QString symbol)
{
    if (mGenes.contains(symbol))
    {
        return mGenes[symbol];
    }
    Gene* gene = new Gene(symbol);
    mGenes.insert(symbol, gene);
    return gene;
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
            mSearchResults->loadJson(json["data"].toArray());
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
