#include "filestreeitem.h"


FilesTreeItem::FilesTreeItem(QObject* parent) : QObject(parent)
{}

FilesTreeItem::FilesTreeItem(int id, QVariant value, QObject* parent) : QObject(parent)
{
    mId= id;
    mValue = value;
}


