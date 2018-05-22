#include "gene.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"




Gene::Gene(QObject* parent): RegovarResource(parent)
{
}
Gene::Gene(QJsonObject json, QObject* parent): Gene(parent)
{
    loadJson(json);
}
Gene::Gene(QString symbol, QObject* parent): Gene(parent)
{
    mSymbol = symbol;
}


bool Gene::loadJson(QJsonObject json)
{
    // Load gene information


    // Panels
    // HPO related
    // - Diseases
    // - Phenotypes

    return true;
}


QJsonObject Gene::toJson()
{
    QJsonObject json;
    json.insert("symbol", mSymbol);
    json.insert("label", mSymbol);

    return json;
}


void Gene::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/search/gene/%1").arg(mSymbol));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                loadJson(json["data"].toObject());
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}

