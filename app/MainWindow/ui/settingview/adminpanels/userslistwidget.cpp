#include "userslistwidget.h"
#include <QSplitter>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include "userlistviewmodel.h"
#include "regovar.h"
#include "app.h"

UsersListWidget::UsersListWidget(QWidget *parent) : AbstractSettingsWidget(parent)
{
    mUsersList = new QTableView;
    mFilter = new QLineEdit;
    QWidget* stretcher = new QWidget;
    stretcher->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Expanding);

    QPushButton* newUser = new QPushButton(tr("Add new user"));
    QPushButton* delUser = new QPushButton(tr("Delete user"));
    QPushButton* edtUser = new QPushButton(tr("Edit user"));
    mFilter->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Preferred);

    QVBoxLayout* leftPanel = new QVBoxLayout;
    leftPanel->addWidget(mFilter);
    leftPanel->addWidget(mUsersList);

    QVBoxLayout* rightPanel = new QVBoxLayout;
    rightPanel->addWidget(newUser);
    rightPanel->addWidget(edtUser);
    rightPanel->addWidget(delUser);
    rightPanel->addWidget(stretcher);


    QHBoxLayout* mainLayout = new QHBoxLayout;
    mainLayout->addLayout(leftPanel);
    mainLayout->addLayout(rightPanel);
    setLayout(mainLayout);
}



bool UsersListWidget::save()
{

    return true;
}

bool UsersListWidget::load()
{
    mUsersList->setModel(new UserListViewModel);
    //regovar->userData()
    return true;
}

void UsersListWidget::onChanged()
{
}
