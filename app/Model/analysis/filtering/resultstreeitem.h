#ifndef RESULTSTREEITEM_H
#define RESULTSTREEITEM_H

#include "Model/framework/treeitem.h"
#include "Model/analysis/filtering/filteringanalysis.h"

//! Generic TreeItem
class ResultsTreeItem : public TreeItem
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)
    Q_PROPERTY(bool isSelected READ isSelected WRITE setIsSelected NOTIFY isSelectedChanged)

public:
    // Constructors
    explicit ResultsTreeItem(FilteringAnalysis* analysis=nullptr, TreeItem* parent=nullptr);

    // Getters
    inline QString uid() { return mUid; }
    inline bool isSelected() const { return mIsSelected; }

    // Setters
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }
    inline void setIsSelected(bool flag) { mIsSelected = flag; emit isSelectedChanged(); }

Q_SIGNALS:
    void uidChanged();
    void isSelectedChanged();

private:
    FilteringAnalysis* mFilteringAnalysis = nullptr;
    QString mUid;
};


#endif // RESULTSTREEITEM_H
