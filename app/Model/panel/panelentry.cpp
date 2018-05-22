#include "panelentry.h"


PanelEntry::PanelEntry(QObject* parent): RegovarResource(parent)
{
}
PanelEntry::PanelEntry(QJsonObject json, QObject* parent): PanelEntry(parent)
{
    loadJson(json);
}


bool PanelEntry::loadJson(QJsonObject json)
{

}


QJsonObject PanelEntry::toJson()
{

}
