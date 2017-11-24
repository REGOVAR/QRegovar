#ifndef DOCUMENTSTREEITEM_H
#define DOCUMENTSTREEITEM_H

#include "Model/framework/treeitem.h"

class DocumentsTreeItem : public TreeItem
{
    Q_OBJECT

public:
    // Constructors
    explicit DocumentsTreeItem(TreeItem* parent=nullptr);
    explicit DocumentsTreeItem(QHash<int, QVariant> columnData, TreeItem* parent=nullptr);



};

#endif // DOCUMENTSTREEITEM_H
