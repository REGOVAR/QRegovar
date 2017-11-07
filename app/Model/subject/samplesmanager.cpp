#include "samplesmanager.h"
#include "sample.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

SamplesManager::SamplesManager(QObject *parent) : QObject(parent)
{
}
SamplesManager::SamplesManager(int refId, QObject *parent) : QObject(parent)
{
    setReferencialId(refId);
}




void SamplesManager::setReferencialId(int refId)
{
    if (refId == mRefId) return;
    mRefId = refId;

    Request* req = Request::get(QString("/sample/browse/%1").arg(refId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mSamplesList.clear();
            foreach( QJsonValue sbjData, json["data"].toArray())
            {
                QJsonObject subject = sbjData.toObject();
                // TODO subject info
                foreach( QJsonValue splData, subject["samples"].toArray())
                {
                    Sample* sample = new Sample();
                    sample->fromJson(splData.toObject());
                    mSamplesList.append(sample);
                }
            }
            emit referencialIdChanged();
            emit samplesListChanged();
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}
