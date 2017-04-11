

#include <QGridLayout>
#include <QVBoxLayout>
#include <QPushButton>
#include <QListWidgetItem>
#include <QIcon>
#include <QSplitter>

#include <QDebug>
#include "projectwidget.h"
#include "app.h"



namespace projectview
{

ProjectWidget::ProjectWidget(QWidget *parent) : QWidget(parent)
{

    // create widget and Layout of the view
    mTitleLabel = new QLabel(tr("Project Name"), this);
    mStatusLabel = new QLabel(tr("[status]"), this);
    mStackWidget = new QStackedWidget(this);
    mResumeTab = new QWidget(this);

    QIcon* ico = new QIcon();
    ico->addPixmap(app->awesome()->icon(fa::folderopeno).pixmap(64, 64), QIcon::Normal, QIcon::On);
    ico->addPixmap(app->awesome()->icon(fa::foldero).pixmap(64, 64), QIcon::Normal, QIcon::Off);
    mToggleBrowserButton = new QPushButton(*ico, tr("Projects"), this);
    mToggleBrowserButton->setCheckable(true);

    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Preferred);

    mToolBar = new QToolBar(this);
    mToolBar->addWidget(mTitleLabel);
    mToolBar->addWidget(mStatusLabel);
    mToolBar->addWidget(stretcher);
    mToolBar->addAction(app->awesome()->icon(fa::pencil),tr("Edit project information"), this, SLOT(showProjectSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::userplus),tr("Add subject/sample to the project"), this, SLOT(showAddSubjectsData()));
    mToolBar->addAction(app->awesome()->icon(fa::cog),tr("Create a new analysis"), this, SLOT(showNewTask()));
    mToolBar->addAction(app->awesome()->icon(fa::calendar),tr("Add a custom event to the history of the project"), this, SLOT(showAddEvent()));
    mToolBar->addAction(app->awesome()->icon(fa::paperclip),tr("Add attachment to the project"), this, SLOT(showAddAttachment()));

    mSectionBar = new QListWidget(this);
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::barchart), tr("Resume")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::user), tr("Subjects")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::cog), tr("Tasks")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::file), tr("Files")));
    mSectionBar->setIconSize(QSize(64,64));
    mSectionBar->setViewMode(QListView::IconMode);
    mSectionBar->setSelectionMode(QAbstractItemView::SingleSelection);
    mSectionBar->setSelectionBehavior(QAbstractItemView::SelectRows);
    mSectionBar->setDragDropMode(QAbstractItemView::NoDragDrop);

    mBrowser = new ProjectsBrowserWidget(this);



    // Create pages
    mResumePage = new ResumeWidget(this);
    mSubjectPage = new QTableWidget(this);
    mTaskPage = new QTableWidget(this);
    mFilePage = new QTreeView(this);

    mStackWidget->addWidget(mResumePage);
    mStackWidget->addWidget(mSubjectPage);
    mStackWidget->addWidget(mTaskPage);
    mStackWidget->addWidget(mFilePage);
    mStackWidget->setCurrentWidget(mResumePage);
    // TODO : currentWidget not set properly the selection in the widget


    // Set main layout
    QGridLayout* panelLayout = new QGridLayout(this);
    panelLayout->addWidget(mToggleBrowserButton, 0, 0);
    panelLayout->addWidget(mSectionBar, 1, 0);
    panelLayout->addWidget(mToolBar, 0, 1);
    panelLayout->addWidget(mStackWidget, 1, 1);
    mSectionBar->setMaximumWidth(75);

    QSplitter* mainWidget = new QSplitter(this);
    QWidget* panel = new QWidget(this);
    panel->setLayout(panelLayout);
    mainWidget->addWidget(mBrowser);
    mainWidget->addWidget(panel);

    QVBoxLayout* mainLayout = new QVBoxLayout(this);
    mainLayout->addWidget(mainWidget);
    setLayout(mainLayout);
    mBrowser->hide();


    // Some Theme customization
    mToggleBrowserButton->setFlat(true);
    // mToggleBrowserButton->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    mTitleLabel->setFont(QFont( "Arial", 18, QFont::Bold));
    mSectionBar->setFrameStyle( QFrame::NoFrame );


    // Create Signals/Slots connections
    connect(mToggleBrowserButton, SIGNAL(released()), this, SLOT(toggleBrowser()));
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
        mTitleLabel->setText(mProject->name());
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
    qDebug() << Q_FUNC_INFO;
}
void ProjectWidget::showAddSubjectsData()
{
    qDebug() << Q_FUNC_INFO;
}
void ProjectWidget::showNewTask()
{
    qDebug() << Q_FUNC_INFO;
}
void ProjectWidget::showAddEvent()
{
    qDebug() << Q_FUNC_INFO;
}
void ProjectWidget::showAddAttachment()
{
    qDebug() << Q_FUNC_INFO;
}
void ProjectWidget::toggleBrowser()
{
    if (mToggleBrowserButton->isChecked())
    {
        mBrowser->show();
    }
    else
    {
        mBrowser->hide();
    }
}


} // END namespace projectview
