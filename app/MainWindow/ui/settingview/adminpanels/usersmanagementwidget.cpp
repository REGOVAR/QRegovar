#include "usersmanagementwidget.h"
#include <QSplitter>
#include <QVBoxLayout>

UsersManagementWidget::UsersManagementWidget(QWidget *parent) : AbstractSettingsWidget(parent)
{
    mUsersList = new QTableView;
    mUserDetails = new MyProfileWidget;

    QSplitter* mainWidget = new QSplitter();
    mainWidget->addWidget(mUsersList);
    mainWidget->addWidget(mUserDetails);

    QVBoxLayout* mainLayout = new QVBoxLayout;
    mainLayout->addWidget(mainWidget);
    setLayout(mainLayout);
}



bool UsersManagementWidget::save()
{

    return true;
}

bool UsersManagementWidget::load()
{
    return true;
}

void UsersManagementWidget::onChanged()
{
}
