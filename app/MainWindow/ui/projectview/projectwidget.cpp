

#include <QGridLayout>
#include <QVBoxLayout>
#include <QPushButton>
#include <QListWidgetItem>
#include <QIcon>
#include <QSplitter>

#include <QDebug>
#include "ui/projectview/projectwidget.h"
#include "app.h"



namespace projectview
{

ProjectWidget::ProjectWidget(QWidget *parent) : QWidget(parent)
{

    // create widget and Layout of the view
    QToolBar* mToolBar;
    mStackWidget = new QStackedWidget(this);


    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Preferred);

    mToolBar = new QToolBar(this);
    mToolBar->setToolButtonStyle( Qt::ToolButtonTextBesideIcon );
    mToolBar->addAction(app->awesome()->icon(fa::foldero),tr("My project"), this, SLOT(toggleBrowser()));
    mToolBar->addWidget(stretcher);
    //mToolBar->addAction(app->awesome()->icon(fa::circle),tr("Urgent"), this, SLOT(showProjectIndicator()));


    mSectionBar = new QListWidget(this);
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::infocircle), tr("Resume")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::calendar), tr("Events")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::user), tr("Subjects")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::cog), tr("Analyses")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::file), tr("Files")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::wrench), tr("Settings")));
    mSectionBar->setIconSize(QSize(22,22));
    mSectionBar->setSelectionMode(QAbstractItemView::SingleSelection);
    mSectionBar->setSelectionBehavior(QAbstractItemView::SelectRows);
    mSectionBar->setDragDropMode(QAbstractItemView::NoDragDrop);


    mSectionBar->viewport()->setAutoFillBackground(false);
    mSectionBar->setFrameStyle(QFrame::NoFrame);


    // Create pages
    mResumeWidget = new ResumeWidget(this);
    mEventsWidget = new EventsWidget(this);
    mSubjectsWidget = new QWidget(this);
    mAnalysesWidget = new AnalysisWidget(this);
    mFilesWidget = new QWidget(this);
    mSettingsWidget = new SettingsWidget(this);

    mStackWidget->addWidget(mResumeWidget);
    mStackWidget->addWidget(mEventsWidget);
    mStackWidget->addWidget(mSubjectsWidget);
    mStackWidget->addWidget(mAnalysesWidget);
    mStackWidget->addWidget(mFilesWidget);
    mStackWidget->addWidget(mSettingsWidget);
    mStackWidget->setCurrentWidget(mResumeWidget);
    // TODO : currentWidget not set properly the selection in the widget


    // Set main layout
    QGridLayout* mainLayout = new QGridLayout(this);
    mainLayout->setContentsMargins(0,0,5,5);
    mainLayout->addWidget(mSectionBar, 1, 0);
    mainLayout->addWidget(mToolBar, 0, 0, 1, 2);
    mainLayout->addWidget(mStackWidget, 1, 1);
    mSectionBar->setMaximumWidth(150);


    setLayout(mainLayout);


    // Create Signals/Slots connections
    connect(mSectionBar, SIGNAL(currentItemChanged(QListWidgetItem *, QListWidgetItem *)), this, SLOT(displaySection(QListWidgetItem *, QListWidgetItem *)));

    mProject = nullptr;
}


void ProjectWidget::initView()
{
    if (mProject == nullptr)
    {

    }
    else
    {
        mResumeWidget->setProject(mProject);
    }
}








const ProjectModel* ProjectWidget::project() const
{
    return mProject;
}
void ProjectWidget::setProject(ProjectModel* project)
{
    mProject = project;
    initView();
}












// SLOTS



void ProjectWidget::displaySection(QListWidgetItem* current, QListWidgetItem* previous)
{
    mStackWidget->setCurrentIndex(mSectionBar->currentRow());
}
void ProjectWidget::showProjectSettings()
{
    qDebug() << "TODO" << Q_FUNC_INFO;
}
void ProjectWidget::showAddSubjectsData()
{
    qDebug() << "TODO" << Q_FUNC_INFO;
}
void ProjectWidget::showNewTask()
{
    qDebug() << "TODO" << Q_FUNC_INFO;
}
void ProjectWidget::showAddEvent()
{
    qDebug() << "TODO" << Q_FUNC_INFO;
}
void ProjectWidget::showAddAttachment()
{
    qDebug() << "TODO" << Q_FUNC_INFO;
}
void ProjectWidget::toggleBrowser()
{
    qDebug() << "TODO" << Q_FUNC_INFO;
}


} // END namespace projectview
