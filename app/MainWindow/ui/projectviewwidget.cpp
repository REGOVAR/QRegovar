#include "app.h"
#include "projectviewwidget.h"
#include <QGridLayout>
#include <QPushButton>
#include <QListWidgetItem>
#include <QIcon>

ProjectViewWidget::ProjectViewWidget(QWidget *parent) : QWidget(parent)
{


    projectTitle = new QLabel(tr("Project Name"), this);
    projectStatus = new QLabel(tr("[status]"), this);
    mStackWidget = new QStackedWidget(this);
    mResumeTab = new QWidget(this);

    QIcon* ico = new QIcon();
    ico->addPixmap(app->awesome()->icon(fa::folderopeno).pixmap(32, 32), QIcon::Normal, QIcon::On);
    ico->addPixmap(app->awesome()->icon(fa::foldero).pixmap(32, 32), QIcon::Normal, QIcon::Off);
    toggleBrowserButton = new QPushButton(*ico, tr("Browse projects"), this);
    toggleBrowserButton->setCheckable(true);

    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Preferred);

    mToolBar = new QToolBar(this);
    mToolBar->addWidget(projectTitle);
    mToolBar->addWidget(projectStatus);
    mToolBar->addWidget(stretcher);
    mToolBar->addAction(app->awesome()->icon(fa::pencil),tr("Edit project information"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::userplus),tr("Add subject/sample to the project"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::cog),tr("Create a new analysis"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::calendar),tr("Add a custom event to the history of the project"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::paperclip),tr("Add attachment to the project"), this, SLOT(showSettings()));


    mSectionBar = new QListWidget(this);
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::barchart), tr("Resume")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::user), tr("Subjects")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::cog), tr("Tasks")));
    mSectionBar->addItem(new QListWidgetItem(app->awesome()->icon(fa::file), tr("Files")));


    QAction test();

    // TODO : use theme color
    toggleBrowserButton->setFlat(true);
    mStackWidget->setStyleSheet("border-top: 1px solid #aaa");
    mSectionBar->setStyleSheet("border-right: 1px solid #aaa");
    projectTitle->setFont(QFont( "Arial", 18, QFont::Bold));



    QGridLayout* mainLayout = new QGridLayout(this);
    mainLayout->addWidget(toggleBrowserButton, 0, 0);
    mainLayout->addWidget(mSectionBar, 1, 0);
    mainLayout->addWidget(mToolBar, 0, 1);
    mainLayout->addWidget(mStackWidget, 1, 1);
    mSectionBar->setMaximumWidth(150);
    setLayout(mainLayout);
}


void ProjectViewWidget::showSettings()
{

}
