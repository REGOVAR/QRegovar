#include "annotationstreeitem.h"


AnnotationsTreeItem::AnnotationsTreeItem(TreeItem *parent) : TreeItem(parent)
{}



AnnotationsTreeItem::AnnotationsTreeItem(const QString uid, const bool checked, const QHash<int, QVariant>& data, TreeItem *parent) : TreeItem(parent)
{
    setUid(uid);
    setChecked(checked);
    setData(data);
}


void AnnotationsTreeItem::setChecked(bool checked)
{
    mIsChecked = checked;
    // Todo : check/uncheck child + notify parent that check state have changed
    emit checkedChanged();
}
