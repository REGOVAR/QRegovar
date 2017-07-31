#include "resultstreeitem.h"


ResultsTreeItem::ResultsTreeItem(QObject *parent) : QObject(parent)
{}

ResultsTreeItem::ResultsTreeItem(const ResultsTreeItem &other) : QObject(other.parent())
{
    mValue = other.mValue;
    mUid= other.mUid;
}

ResultsTreeItem::~ResultsTreeItem()
{}



ResultsTreeItem::ResultsTreeItem(QString uid, QVariant value, QObject *parent) : QObject(parent)
{
    mValue = value;
    mUid= uid;
}
