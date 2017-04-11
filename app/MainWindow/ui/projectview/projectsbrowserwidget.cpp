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


    QVBoxLayout* mainLayout = new QVBoxLayout();
    mainLayout->addWidget(mToolBar);
    mainLayout->addWidget(mBrowser);
    setLayout(mainLayout);

    setMinimumWidth(200);


}




void ProjectsBrowserWidget::toggleFilesDisplay()
{

}

void ProjectsBrowserWidget::showFavorites()
{

}



} // END namespace projectview
