#include "app.h"
#include "projectviewwidget.h"
#include <QLabel>
#include <QPushButton>

ProjectViewWidget::ProjectViewWidget(QWidget *parent) : QWidget(parent)
{
    QHBoxLayout* mainLayout = new QHBoxLayout(this);
    QVBoxLayout* contentLayout = new QVBoxLayout(this);

    mSectionBar = new QToolBar(this);
    mToolBar = new QToolBar(this);
    mStackWidget = new QStackedWidget(this);
    mResumeTab = new QWidget(this);

    contentLayout->addWidget(mToolBar);
    contentLayout->addWidget(mStackWidget);
    mainLayout->addWidget(mSectionBar);
    mainLayout->addLayout(contentLayout);
    setLayout(mainLayout);

    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Preferred);
    projectTitle = new QLabel(tr("Project Name"), this);
    projectStatus = new QLabel(tr("[status]"), this);

    mToolBar->addWidget(projectTitle);
    mToolBar->addWidget(projectStatus);
    mToolBar->addWidget(stretcher);
    mToolBar->addAction(app->awesome()->icon(fa::pencil),tr("Edit project information"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::userplus),tr("Add subject/sample to the project"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::cog),tr("Create a new analysis"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::calendar),tr("Add a custom event to the history of the project"), this, SLOT(showSettings()));
    mToolBar->addAction(app->awesome()->icon(fa::paperclip),tr("Add attachment to the project"), this, SLOT(showSettings()));

    QPushButton* toggleBrowserButton = new QPushButton(tr("Browse projects"),this);
    mSectionBar->setOrientation(Qt::Vertical);
    mSectionBar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    mSectionBar->setIconSize(QSize(64,64));


    // TODO : use theme color
    mainLayout->setContentsMargins(0,0,0,0);
    contentLayout->setContentsMargins(0,0,0,0);
    mStackWidget->setStyleSheet("border-top: 1px solid #aaa");
    mSectionBar->setStyleSheet("border-right: 1px solid #aaa");
    projectTitle->setFont(QFont( "Arial", 18, QFont::Bold));


    mSectionBar->addWidget(toggleBrowserButton);
    mSectionBar->addAction(app->awesome()->icon(fa::barchart),tr("Resume"), this, SLOT(showSettings()));
    mSectionBar->addAction(app->awesome()->icon(fa::user),tr("Subjects"), this, SLOT(showSettings()));
    mSectionBar->addAction(app->awesome()->icon(fa::cog),tr("Tasks"), this, SLOT(showSettings()));
    mSectionBar->addAction(app->awesome()->icon(fa::file),tr("Files"), this, SLOT(showSettings()));

}


void ProjectViewWidget::showSettings()
{

}
