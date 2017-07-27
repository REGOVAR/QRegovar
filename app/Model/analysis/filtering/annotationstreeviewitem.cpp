#include "annotationstreeviewitem.h"


AnnotationsTreeViewItem::AnnotationsTreeViewItem(QObject *parent) : QObject(parent)
{}

AnnotationsTreeViewItem::AnnotationsTreeViewItem(const AnnotationsTreeViewItem &other)
{
    mValue = other.mValue;
    mId= other.mId;
}

AnnotationsTreeViewItem::~AnnotationsTreeViewItem()
{}



AnnotationsTreeViewItem::AnnotationsTreeViewItem(QString id, QVariant value, QObject *parent) : QObject(parent)
{
    mValue = value;
    mId= id;
}
