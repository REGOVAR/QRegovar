#include "toolparameter.h"

ToolParameter::ToolParameter(QObject* parent) :  QObject(parent) {}
ToolParameter::ToolParameter(QJsonObject json, QObject* parent)
{
    mKey = json["key"].toString();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mType = json["type"].toString();
    mValue = json["count"].toVariant();
    mDefaultValue = json["size"].toVariant();
    mRequired = json["totalsize"].toBool();

    foreach (QJsonValue val, json["enum"].toArray())
    {
        mEnumValues << val.toString();
    }
}


QJsonObject ToolParameter::toJson()
{
    QJsonObject result;
    result.insert(mKey, mValue.toJsonValue());
    return result;
}


void ToolParameter::clear()
{
    mValue = mDefaultValue;
}
