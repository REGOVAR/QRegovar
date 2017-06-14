#include "jobwidget.h"
#include "ui/jobview/infojobviewer.h"

JobWidget::JobWidget(QWidget* parent) : QWidget(parent)
{
    QSplitter* splitter = new QSplitter(Qt::Vertical);
    mJobListView = new JobListView();
    mJobListModel = new JobListModel();
    mJobView = new JobView();
    mJobListView->setModel(mJobListModel);
    mJobListModel->refresh();

    splitter->addWidget(mJobListView);
    splitter->addWidget(mJobView);

    QVBoxLayout* mainLayout = new QVBoxLayout();
    mainLayout->addWidget(splitter);
    mainLayout->setContentsMargins(0,0,0,0);

    addViewer(new InfoJobViewer());
    connect(mJobListView, SIGNAL(clicked(QModelIndex)), this, SLOT(setCurrentJob(QModelIndex)));

    setLayout(mainLayout);
}

void JobWidget::addViewer(AbstractJobViewer *viewer)
{
    mViewers.append(viewer);
    mJobView->addTab(viewer, viewer->windowIcon(), viewer->windowTitle());
}

void JobWidget::setCurrentJob(QModelIndex index)
{
    for (AbstractJobViewer* v : mViewers)
    {
        v->setJob(mJobListModel->job(index));
    }
}
