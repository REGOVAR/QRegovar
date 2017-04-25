#include "userslistwidget.h"
#include <QSplitter>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QMessageBox>
#include <QHeaderView>
#include "regovar.h"
#include "app.h"

UsersListWidget::UsersListWidget(QWidget *parent) : AbstractSettingsWidget(parent)
{
    // Create VM and connect events
    mUserListViewModel = new UserListViewModel;



    mFilter = new QLineEdit;
    mUsersList = new QTableView;
    mUsersList->horizontalHeader()->setStretchLastSection(true);
    mUsersList->setSelectionBehavior(QAbstractItemView::SelectRows);
    mUsersList->setSelectionMode(QAbstractItemView::SingleSelection);
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

    connect(mFilter, &QLineEdit::textChanged, this, &UsersListWidget::FilterUsersList);
    connect(newUser, &QPushButton::clicked, this, &UsersListWidget::displayAddUser);
    connect(edtUser, &QPushButton::clicked, this, &UsersListWidget::displayEditUser);
    connect(delUser, &QPushButton::clicked, this, &UsersListWidget::displayDeleteUser);
}



UserModel* UsersListWidget::selectedUser()
{
    QItemSelectionModel* select = mUsersList->selectionModel();
    if (select->hasSelection() )
    {
        // only one row can be selected
        return mUserListViewModel->at(select->selectedRows().at(0).row());
    }
    return nullptr;
}



void UsersListWidget::displayAddUser()
{

}
void UsersListWidget::displayEditUser()
{

}
void UsersListWidget::displayDeleteUser()
{
    UserModel* user = selectedUser();
    if (user != nullptr)
    {
        if(QMessageBox::question(this,
                                 tr("Delete user confirmation"),
                                 tr("Are you sure to delete the user : <b>%1 %2 (%3)</b> ?").arg(user->firstname(), user->lastname(), user->login()),
                                 QMessageBox::Yes, QMessageBox::No) == QMessageBox::Yes)
        {
            // TODO : delete the user
            mUserListViewModel->deleteUser(user->id());
        }
    }
    else
    {
        QMessageBox::information(this, tr("Delete user"), tr("You need to select a user first."), QMessageBox::Ok);
    }
}
void UsersListWidget::FilterUsersList()
{

}



bool UsersListWidget::save()
{
    return true;
}

bool UsersListWidget::load()
{
    mUsersList->setModel(mUserListViewModel);
    return true;
}

void UsersListWidget::onChanged()
{

}


