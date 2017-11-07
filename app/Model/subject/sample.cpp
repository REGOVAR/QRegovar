#include "sample.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"



Sample::Sample(QObject *parent) : QObject(parent)
{
}


Sample::Sample(QJsonObject json, QObject* parent) : QObject(parent)
{
    fromJson(json);
}

void Sample::setStatus(QString status)
{
    auto meta = QMetaEnum::fromType<SampleStatus>();
    setStatus(static_cast<SampleStatus>(meta.keyToValue(status.toStdString().c_str()))); // T_T .... tout ça pour ça ....
}

bool Sample::fromJson(QJsonObject json)
{
    // load basic data from json
    mId = json["id"].toInt();
    setName(json["name"].toString());
    setNickname(""); // Todo
    setIsMosaic(json["is_mosaic"].toBool());
    setComment(json["comment"].toString());

    mReference = regovar->referenceFromId(json["reference_id"].toInt());

    mDefaultAnnotationsDbUid.clear();
    foreach (const QJsonValue field, json["default_dbuid"].toArray())
    {
        mDefaultAnnotationsDbUid << field.toString();
    }

    setStatus(json["status"].toString());

    File* source = new File();
    source->fromJson(json["file"].toObject());
    setSource(source);
    setSourceUI(source->filenameUI());

    // Retrieve subject
    int subjectId = json["subject_id"].toInt();
    if (subjectId > 0)
    {
        mSubject = regovar->subjectsManager()->getOrCreateSubject(subjectId);
    }

    QJsonObject nameInfo;
    nameInfo.insert("name", mName);
    nameInfo.insert("nickname", mNickname);
    setNameUI(QVariant::fromValue(nameInfo));

    QJsonObject statusInfo;
    statusInfo.insert("status", mStatus);
    statusInfo.insert("label", statusToLabel(mStatus, json["loading_progress"].toDouble()));
    setStatusUI(QVariant::fromValue(statusInfo));

	return true;
}


QJsonObject Sample::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("is_mosaic", mIsMosaic);
    result.insert("comment", mComment);
    if (mSubject != nullptr && mSubject->id() != -1)
    {
        result.insert("subject_id", mSubject->id());
    }
    else
    {
        result.insert("subject_id", QJsonValue::Null);
    }

    return result;
}



void Sample::save()
{
    if (mId == -1) return;

    Request* request = Request::put(QString("/sample/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Sample saved";
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        request->deleteLater();
    });
}



void Sample::load()
{
    Request* req = Request::get(QString("/sample/%1").arg(mId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            fromJson(json["data"].toObject());
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



QString Sample::statusToLabel(SampleStatus status, double progress)
{

    if(status == loading)
    {
        return tr("Loading") + QString(" (%1%)").arg(QString::number( progress*100, 'f', 2 ));
    }
    if(status == ready) return tr("Ready");
    if(status == empty) return tr("Waiting for loading...");
    return tr("Error");
}