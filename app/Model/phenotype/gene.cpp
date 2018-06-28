#include "gene.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"




Gene::Gene(QObject* parent): RegovarResource(parent)
{
    mPhenotypes = new PhenotypesListModel(this);
    mDiseases = new DiseasesListModel(this);
    mPubmed = new JsonListModel(this);
    mPanels = new PanelsListModel(this);
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


bool Gene::loadJson(const QJsonObject& json, bool)
{
    // Load gene information
    mSymbol = json["symbol"].toString();
    mJson = json;

    // Panels
    if (json.contains("panels"))
    {
        mPanels->clear();
        for(const QJsonValue& val: json["panels"].toArray())
        {
            mPanels->append(regovar->panelsManager()->getPanelVersion(val.toString()));
        }
    }

    // HPO related
    if (json.contains("hpo"))
    {
        QJsonObject hpo = json["hpo"].toObject();
        mPhenotypes->clear();
        for(const QJsonValue& val: hpo["phenotypes"].toArray())
        {
            QJsonObject pheno = val.toObject();
            Phenotype* p = (Phenotype*) regovar->phenotypesManager()->getOrCreate(pheno["id"].toString());
            p->loadJson(pheno);
            mPhenotypes->append(p);
        }
        mDiseases->clear();
        for(const QJsonValue& val: hpo["diseases"].toArray())
        {
            QJsonObject disea = val.toObject();
            Disease* d = (Disease*) regovar->phenotypesManager()->getOrCreate(disea["id"].toString());
            d->loadJson(disea);
            mDiseases->append(d);
        }
    }

    // Pubmed
    if (json.contains("pubmed"))
    {
        mPubmed->clear();
        for(const QJsonValue& val: json["pubmed"].toArray())
        {
            mPubmed->append(val.toObject());
        }
    }

    mLoaded = true;
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
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}
