#include "treeitem.h"
#include <QStringList>



TreeItem::TreeItem(TreeItem* parent) : QObject(parent)
{
    mParentItem = parent;
    mVirtualChildCount = 0;
}

TreeItem::TreeItem(const QHash<int, QVariant>& data, TreeItem* parent) : QObject(parent)
{
    mParentItem = parent;
    mItemData = data;
    mVirtualChildCount = 0;
}

TreeItem::~TreeItem()
{
    qDeleteAll(mChildItems);
}

TreeItem *TreeItem::child(int number)
{
    return mChildItems.value(number);
}

int TreeItem::childCount() const
{
    return mChildItems.count();
}

void TreeItem::appendChild(TreeItem *item)
{
    mChildItems.append(item);
}

void TreeItem::setData(const QHash<int, QVariant>& data)
{
    mItemData = data;
}

int TreeItem::row() const
{
    if (mParentItem)
        return mParentItem->mChildItems.indexOf(const_cast<TreeItem*>(this));

    return 0;
}

int TreeItem::columnCount() const
{
    return mItemData.count();
}

QVariant TreeItem::data(int column) const
{
    if (mItemData.contains(column))
        return mItemData[column];
    return QVariant();
}



TreeItem* TreeItem::parent()
{
    return mParentItem;
}



void TreeItem::recursiveDelete()
{
    foreach (TreeItem* child, mChildItems)
    {
        child->recursiveDelete();
    }

    mParentItem = nullptr;
    mChildItems.clear();
}





