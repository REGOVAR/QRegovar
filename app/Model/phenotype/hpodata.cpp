#include "hpodata.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"



HpoData::HpoData(QObject* parent) : QObject(parent)
{
    mGenes = new GenesListModel(this);
    mSubjects = new SubjectsListModel(this);
}


bool HpoData::loadJson(QJsonObject)
{
    return false;
}

bool HpoData::load(bool forceRefresh)
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
    return true;
}
