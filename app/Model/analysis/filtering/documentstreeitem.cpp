#include "documentstreeitem.h"

DocumentsTreeItem::DocumentsTreeItem(TreeItem *parent) : TreeItem(parent)
{
}
DocumentsTreeItem::DocumentsTreeItem(QHash<int, QVariant> columnData, TreeItem *parent) : TreeItem(columnData, parent)
{
}
