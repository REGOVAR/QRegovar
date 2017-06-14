#ifndef JOBLISTVIEW_H
#define JOBLISTVIEW_H

#include <QtWidgets>

class JobListView : public QTableView
{
    Q_OBJECT
public:
    JobListView(QWidget* parent=nullptr);
};

#endif // JOBLISTVIEW_H
