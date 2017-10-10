#include "resultstreeitem.h"




ResultsTreeItem::ResultsTreeItem(FilteringAnalysis* analysis, TreeItem* parent) : TreeItem(parent)
{
    mFilteringAnalysis = analysis;
}

