#include "attribute.h"

Attribute::Attribute(QObject* parent) : QObject(parent)
{
}
Attribute::Attribute(QString name) : QObject(nullptr)
{
    mName = name;
}
Attribute::Attribute(QJsonObject json) : QObject(nullptr)
{
    loadJson(json);
}


QJsonObject Attribute::toJson()
{
    QJsonObject result;
    result.insert("name", mName);
    QJsonObject values;
    for (const int sid: mSamplesValues.keys())
    {
        values.insert(QString::number(sid), mSamplesValues[sid]);
    }
    result.insert("samples_values", values);
    return result;
}



bool Attribute::loadJson(QJsonObject json)
{
    mName = json["name"].toString();
    QJsonObject values = json["samples_values"].toObject();

    for (const QString& sid: values.keys())
    {
        QJsonObject data = values[sid].toObject();
        QString value = data["value"].toString();
        QString wtid =  data["wt_col_id"].toString();

        mSamplesValues[sid.toInt()] = value;
        mMapping[value] = wtid;

    }
    return true;
}

