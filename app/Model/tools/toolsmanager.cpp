#include "toolsmanager.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"
#include "tool.h"



ToolsManager::ToolsManager(QObject* parent) : QObject(parent)
{
}


bool ToolsManager::loadJson(QJsonObject json)
{
    // Get custom export tools deployed
    for (const QJsonValue& val: json["exporters"].toArray())
    {
        mExporters.append(new Tool(Tool::Exporter, val.toObject()));
    }
    // TODO: Get custom report tools deployed
}
