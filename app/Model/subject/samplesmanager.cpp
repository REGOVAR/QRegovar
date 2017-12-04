#include "samplesmanager.h"
#include "sample.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

SamplesManager::SamplesManager(QObject *parent) : QObject(parent)
{
}
SamplesManager::SamplesManager(int refId, QObject *parent) : QObject(parent)
{
    setReferenceId(refId);
}




void SamplesManager::setReferenceId(int refId)
{
    if (refId == mRefId) return;
    mRefId = refId;

    Request* req = Request::get(QString("/sample/browse/%1").arg(refId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            mSamplesList.clear();
            for (const QJsonValue& sbjData: json["data"].toArray())
            {
                QJsonObject subject = sbjData.toObject();
                // TODO subject info
                for (const QJsonValue& splData: subject["samples"].toArray())
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



void SamplesManager::processPushNotification(QString action, QJsonObject data)
{
    if (action == "import_vcf_processing")
    {
        double progressValue = data["progress"].toDouble();
        QString status = data["status"].toString();

        for (const QJsonValue& json: data["samples"].toArray())
        {
            QJsonObject obj = json.toObject();
            int sid = obj["id"].toInt();
            for (QObject* o: mSamplesList)
            {
                Sample* sample = qobject_cast<Sample*>(o);
                if (sample->id() == sid)
                {
                    sample->setStatus(status);
                    QJsonObject statusInfo;
                    statusInfo.insert("status", status);
                    statusInfo.insert("label", sample->statusToLabel(sample->status(), progressValue));
                    sample->setStatusUI(QVariant::fromValue(statusInfo));
                    break;
                }
            }
        }
    }
}
