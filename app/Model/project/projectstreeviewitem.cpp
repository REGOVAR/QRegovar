#include "projectstreeviewitem.h"


ProjectsTreeViewItem::ProjectsTreeViewItem(QObject *parent) : QObject(parent)
{}

ProjectsTreeViewItem::ProjectsTreeViewItem(const ProjectsTreeViewItem &other)
{
    mText = other.mText;
    mId= other.mId;
}

ProjectsTreeViewItem::~ProjectsTreeViewItem()
{}



ProjectsTreeViewItem::ProjectsTreeViewItem(int id, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mId= id;
}
