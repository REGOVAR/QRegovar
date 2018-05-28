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
    updateSearchField();
}

void Gene::updateSearchField()
{
    mSearchField = mSymbol;
}


bool Gene::loadJson(QJsonObject json, bool)
{
    // Load gene information
    mSymbol = json["symbol"].toString();
    mJson = json;

    // Panels
    // HPO related
    // - Diseases
    // - Phenotypes
    updateSearchField();
    emit dataChanged();
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
    if (!mLoaded || forceRefresh)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/search/gene/%1").arg(mSymbol));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                loadJson(json["data"].toObject());
                mLoaded = true;
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}
