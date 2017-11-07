#ifndef RESULTSTREEITEM_H
#define RESULTSTREEITEM_H

#include "Model/framework/treeitem.h"
#include "Model/analysis/filtering/filteringanalysis.h"

//! Generic TreeItem
class ResultsTreeItem : public TreeItem
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid WRITE setUid NOTIFY uidChanged)

public:
    explicit ResultsTreeItem(FilteringAnalysis* analysis=nullptr, TreeItem* parent=nullptr);
    explicit ResultsTreeItem(QString uid, QVariant text, FilteringAnalysis* analysis=nullptr, int childCount=0, TreeItem* parent=nullptr);



    inline QString uid() { return mUid; }
    inline void setUid(QString uid) { mUid = uid; emit uidChanged(); }

signals:
    void uidChanged();

private:
    FilteringAnalysis* mFilteringAnalysis = nullptr;
    QString mUid;
};


#endif // RESULTSTREEITEM_H
