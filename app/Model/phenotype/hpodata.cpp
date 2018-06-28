#include "hpodata.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"
#include "Model/subject/subjectslistmodel.h"
#include "geneslistmodel.h"



HpoData::HpoData(QObject* parent) : RegovarResource(parent)
{
    mGenes = new GenesListModel(this);
    mSubjects = new SubjectsListModel(this);
}


bool HpoData::loadJson(const QJsonObject&, bool)
{
    return false;
}

void HpoData::load(bool)
{
    Request* req = Request::get(QString("/search/phenotype/%1").arg(mId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();
            loadJson(data);
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}
