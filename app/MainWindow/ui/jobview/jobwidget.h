#ifndef JOBWIDGET_H
#define JOBWIDGET_H

#include <QtWidgets>
#include "ui/jobview/joblistmodel.h"
#include "ui/jobview/joblistview.h"
#include "ui/jobview/jobview.h"
#include "ui/jobview/abstractjobviewer.h"

class JobWidget : public QWidget
{
    Q_OBJECT
public:
    explicit JobWidget(QWidget* parent=nullptr);
    void addViewer(AbstractJobViewer* viewer);

signals:

public slots:
    void setCurrentJob(QModelIndex index);

private:
    JobListModel* mJobListModel;
    JobListView* mJobListView;
    JobView* mJobView;
    QList<AbstractJobViewer*> mViewers;
};

#endif // JOBWIDGET_H
