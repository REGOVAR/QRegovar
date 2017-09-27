#include "sample.h"



Sample::Sample(QObject *parent) : QObject(parent)
{
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

    mDefaultAnnotationsDbUid.clear();
    foreach (const QJsonValue field, json["default_dbuid"].toArray())
    {
        mDefaultAnnotationsDbUid << field.toString();
    }

    setStatus(json["status"].toString());

    File* source = new File();
    source->fromJson(json["file"].toObject());
    setSource(source);
    setSourceUI(source->name());

    QJsonObject nameInfo;
    nameInfo.insert("name", mName);
    nameInfo.insert("nickname", mNickname);
    setStatusUI(QVariant::fromValue(nameInfo));

    QJsonObject subjectInfo;
    subjectInfo.insert("firstname", "Michel"); // todo
    subjectInfo.insert("lastname", "DUPONT");  // todo
    subjectInfo.insert("age", "54y");          // todo
    subjectInfo.insert("sex", "M");            // todo
    setSubjectUI(QVariant::fromValue(subjectInfo));

    QJsonObject statusInfo;
    statusInfo.insert("status", mStatus);
    statusInfo.insert("label", statusToLabel(mStatus, json["loading_progress"].toDouble()));
    setStatusUI(QVariant::fromValue(statusInfo));

    setSourceUI(source->filenameUI());
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
