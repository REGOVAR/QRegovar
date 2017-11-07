#include "projectstreeitem.h"


ProjectsTreeItem::ProjectsTreeItem(QObject *parent) : QObject(parent)
{}

ProjectsTreeItem::ProjectsTreeItem(const ProjectsTreeItem &other) : QObject(other.parent())
{
    mText = other.mText;
    mId= other.mId;
}

ProjectsTreeItem::~ProjectsTreeItem()
{}



ProjectsTreeItem::ProjectsTreeItem(int id, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mId= id;
}
