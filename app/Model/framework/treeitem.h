#ifndef TREEITEM_H
#define TREEITEM_H

#include <QList>
#include <QHash>
#include <QVariant>

class TreeItem : public QObject
{
    Q_OBJECT
public:
    explicit TreeItem(TreeItem* parent=nullptr);
    explicit TreeItem(const QHash<int, QVariant> &data, TreeItem* parent=nullptr);
    ~TreeItem();

    Q_INVOKABLE void appendChild(TreeItem *child);

    Q_INVOKABLE TreeItem *child(int number);
    Q_INVOKABLE int childCount() const;
    Q_INVOKABLE int columnCount() const;
    Q_INVOKABLE QVariant data(int column) const;
    Q_INVOKABLE int row() const;
    Q_INVOKABLE TreeItem *parent();
    Q_INVOKABLE void recursiveDelete();
    Q_INVOKABLE void setData(const QHash<int, QVariant> &data);

    // Lazy loading features
    inline int virtualChildCount() const { return mVirtualChildCount; }
    inline void setVirtualChildCount(int count) { mVirtualChildCount = count; }

//    inline int childNumber() const;
//    bool insertChildren(int position, int count, int columns);
//    bool insertColumns(int position, int columns);
//    bool removeChildren(int position, int count);
//    bool removeColumns(int position, int columns);
//    bool setData(int column, const QVariant &value);

protected:
    QList<TreeItem*> mChildItems;
    QHash<int, QVariant> mItemData;
    TreeItem* mParentItem = nullptr;
    bool mIsSelected;

    int mVirtualChildCount; // number of children (used to know if need to load children)
};

#endif // TREEITEM_H 
