#include "projectsbrowserwidget.h"

#include <QVBoxLayout>
#include <QSizePolicy>
#include "app.h"



namespace projectview
{



ProjectsBrowserWidget::ProjectsBrowserWidget(QWidget *parent) : QWidget(parent)
{
    mFilter = new QLineEdit(parent);
    mToolBar = new QToolBar(parent);
    mBrowser = new QTreeWidget(parent);


    mToolBar->addAction(app->awesome()->icon(fa::fileso),tr("Display files of projects"), this, SLOT(toggleFilesDisplay()));
    mToolBar->addAction(app->awesome()->icon(fa::star),tr("My favorites filters"), this, SLOT(showFavorites()));
    mToolBar->addWidget(mFilter);
    mFilter->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Ignored);


    QVBoxLayout* mainlayout = new QVBoxLayout();
    mainlayout->addWidget(mToolBar);
    mainlayout->addWidget(mBrowser);
    setLayout(mainlayout);

    setMinimumWidth(200);
    setStyleSheet("background-color: #aaa;");

}




void ProjectsBrowserWidget::toggleFilesDisplay()
{

}

void ProjectsBrowserWidget::showFavorites()
{

}



} // END namespace projectview
