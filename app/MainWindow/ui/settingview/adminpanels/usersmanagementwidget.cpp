#include "usersmanagementwidget.h"
#include <QSplitter>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include "model/userlistmodel.h"
#include "regovar.h"
#include "app.h"

UsersManagementWidget::UsersManagementWidget(QWidget *parent) : AbstractSettingsWidget(parent)
{
    mUsersList = new QTableView;
    mUserDetails = new MyProfileWidget;
    mFilter = new QLineEdit;

    QPushButton* newUser = new QPushButton(app->awesome()->icon(fa::userplus), tr("Add new user"));

    QHBoxLayout* toolBar = new QHBoxLayout;
    toolBar->setContentsMargins(0,0,0,0);
    toolBar->addWidget(newUser);
    toolBar->addWidget(mFilter);

    QVBoxLayout* leftLayout = new QVBoxLayout;
    leftLayout->setContentsMargins(0,0,0,0);
    leftLayout->addLayout(toolBar);
    leftLayout->addWidget(mUsersList);

    QWidget* leftPanel = new QWidget;
    leftPanel->setContentsMargins(0,0,0,0);
    leftPanel->setLayout(leftLayout);


    QSplitter* mainWidget = new QSplitter();
    mainWidget->setContentsMargins(0,0,0,0);
    mainWidget->addWidget(leftPanel);
    mainWidget->addWidget(mUserDetails);

    QVBoxLayout* mainLayout = new QVBoxLayout;
    mainLayout->setContentsMargins(0,0,0,0);
    mainLayout->addWidget(mainWidget);
    setLayout(mainLayout);
}



bool UsersManagementWidget::save()
{

    return true;
}

bool UsersManagementWidget::load()
{
    mUsersList->setModel(new UserListModel);
    //regovar->userData()
    return true;
}

void UsersManagementWidget::onChanged()
{
}
