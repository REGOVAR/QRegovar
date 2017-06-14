#include "joblistview.h"



JobListView::JobListView(QWidget *parent) : QTableView(parent)
{
    verticalHeader()->hide();
    horizontalHeader()->setStretchLastSection(true);
    setAlternatingRowColors(true);
    setIconSize(QSize(22,22));
    setShowGrid(false);
    setSelectionBehavior(QAbstractItemView::SelectRows);
    setSelectionMode(QAbstractItemView::ExtendedSelection);
}
