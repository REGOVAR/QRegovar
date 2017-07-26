#include "resultstreeviewitem.h"


ResultsTreeViewItem::ResultsTreeViewItem(QObject *parent) : QObject(parent)
{}

ResultsTreeViewItem::ResultsTreeViewItem(const ResultsTreeViewItem &other)
{
    mText = other.mText;
    mUid= other.mUid;
}

ResultsTreeViewItem::~ResultsTreeViewItem()
{}



ResultsTreeViewItem::ResultsTreeViewItem(QString uid, QString text, QObject *parent) : QObject(parent)
{
    mText = text;
    mUid= uid;
}
