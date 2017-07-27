#include "annotationstreeviewitem.h"


AnnotationsTreeViewItem::AnnotationsTreeViewItem(QObject *parent) : QObject(parent)
{}

AnnotationsTreeViewItem::AnnotationsTreeViewItem(const AnnotationsTreeViewItem &other)
{
    mValue = other.mValue;
    mUid= other.mUid;
}

AnnotationsTreeViewItem::~AnnotationsTreeViewItem()
{}



AnnotationsTreeViewItem::AnnotationsTreeViewItem(QString uid, QVariant value, QObject *parent) : QObject(parent)
{
    mValue = value;
    mUid= uid;
}
