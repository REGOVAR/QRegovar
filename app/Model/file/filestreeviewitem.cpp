#include "filestreeviewitem.h"


FilesTreeViewItem::FilesTreeViewItem(QObject *parent) : QObject(parent)
{}

FilesTreeViewItem::FilesTreeViewItem(const FilesTreeViewItem &other) : QObject(other.parent())
{
    mText = other.mText;
    mId= other.mId;
}

FilesTreeViewItem::~FilesTreeViewItem()
{}



FilesTreeViewItem::FilesTreeViewItem(int id, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mId= id;
}


