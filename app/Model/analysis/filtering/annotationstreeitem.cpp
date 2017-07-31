#include "annotationstreeitem.h"


AnnotationsTreeItem::AnnotationsTreeItem(QObject *parent) : QObject(parent)
{}

AnnotationsTreeItem::AnnotationsTreeItem(const AnnotationsTreeItem &other) : QObject(other.parent())
{
    mValue = other.mValue;
    mUid= other.mUid;
}

AnnotationsTreeItem::~AnnotationsTreeItem()
{}



AnnotationsTreeItem::AnnotationsTreeItem(QString uid, QVariant value, QObject *parent) : QObject(parent)
{
    mValue = value;
    mUid= uid;
}
