#include "filemodel.h"



FileModel::FileModel(QObject* parent) : QObject(parent)
{
}




bool FileModel::fromJson(QJsonDocument json)
{
    QJsonObject data = json.object();
    return fromJson(data);
}


bool FileModel::fromJson(QJsonObject json)
{

    mId = json["id"].toInt();
    mName = json["name"].toString();
    mComment = json["comment"].toString();
    mUrl = QUrl(json["path"].toString());
    mCreationDate = QDateTime::fromString(json["creation_date"].toString());
    mUpdateDate = QDateTime::fromString(json["update_date"].toString());
    mMd5Sum = json["md5sum"].toString();
    mType = json["type"].toString();
    mSize = json["size"].toInt();
    mUploadOffset = json["upload_offset"].toInt();


    auto meta = QMetaEnum::fromType<FileStatus>();
    mStatus = static_cast<FileStatus>(meta.keyToValue(json["status"].toString().toStdString().c_str())); // T_T .... tout ça pour ça ....


    // TODO
    //mTags;
    //mSource;
    //mLocalPath;

    return true;
}
