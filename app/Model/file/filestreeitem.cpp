#include "filestreeitem.h"


FilesTreeItem::FilesTreeItem(QObject *parent) : QObject(parent)
{}

FilesTreeItem::FilesTreeItem(const FilesTreeItem &other) : QObject(other.parent())
{
    mText = other.mText;
    mId= other.mId;
}

FilesTreeItem::~FilesTreeItem()
{}



FilesTreeItem::FilesTreeItem(int id, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mId= id;
}


