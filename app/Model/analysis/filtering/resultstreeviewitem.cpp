#include "resultstreeviewitem.h"


ResultsTreeViewItem::ResultsTreeViewItem(QObject *parent) : QObject(parent)
{}

ResultsTreeViewItem::ResultsTreeViewItem(const ResultsTreeViewItem &other)
{
    mValue = other.mValue;
    mUid= other.mUid;
}

ResultsTreeViewItem::~ResultsTreeViewItem()
{}



ResultsTreeViewItem::ResultsTreeViewItem(QString uid, QVariant value, QObject *parent) : QObject(parent)
{
    mValue = value;
    mUid= uid;
}
