#ifndef DOCUMENTSTREEITEM_H
#define DOCUMENTSTREEITEM_H

#include "Model/framework/treeitem.h"

class DocumentsTreeItem : public TreeItem
{
    Q_OBJECT

public:
    // Constructors
    DocumentsTreeItem(TreeItem* parent=nullptr);
    DocumentsTreeItem(QHash<int, QVariant> columnData, TreeItem* parent=nullptr);



};

#endif // DOCUMENTSTREEITEM_H
