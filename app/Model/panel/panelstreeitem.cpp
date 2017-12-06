#include "panelstreeitem.h"

PanelsTreeItem::PanelsTreeItem(QObject* parent) : QObject(parent)
{}

PanelsTreeItem::PanelsTreeItem(int id, QString version, QString text, QObject* parent) : QObject(parent)
{
    mId = id;
    mVersion = version;
    mText = text;
}
