#include "tool.h"

Tool::Tool(QObject *parent) :  QObject(parent) {}
Tool::Tool(QJsonObject json, QObject* parent) :  QObject(parent)
{
    mKey = json["key"].toString();
    mName = json["name"].toString();
    mDescription = json["description"].toString();

    foreach (QJsonValue val, json["parameters"].toArray())
    {
        mParameters << new ToolParameter(val.toObject());
    }
}





QJsonObject Tool::toJson()
{
    QJsonObject parameters;
    foreach (QObject* o, mParameters)
    {
        ToolParameter* param = qobject_cast<ToolParameter*>(o);
        parameters.insert(param->key(), param->value().toJsonValue());
    }
    return parameters;
}

void Tool::clear()
{
    foreach (QObject* o, mParameters)
    {
        ToolParameter* param = qobject_cast<ToolParameter*>(o);
        param->clear();
    }
}
