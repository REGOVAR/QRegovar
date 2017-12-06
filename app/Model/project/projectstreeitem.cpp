#include "projectstreeitem.h"


ProjectsTreeItem::ProjectsTreeItem(QObject *parent) : QObject(parent)
{}


ProjectsTreeItem::ProjectsTreeItem(int id, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mId= id;
}
