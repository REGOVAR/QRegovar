#ifndef USERSLISTWIDGET_H
#define USERSLISTWIDGET_H

#include <QWidget>
#include <QTableView>
#include <QLineEdit>
#include "../abstractsettingswidget.h"
#include "userlistviewmodel.h"
#include "model/usermodel.h"


class UsersListWidget : public AbstractSettingsWidget
{
    Q_OBJECT
public:
    explicit UsersListWidget(QWidget *parent = 0);

    UserModel* selectedUser();

public Q_SLOTS:
    bool save();
    bool load();
    void onChanged();

    void FilterUsersList();
    void displayAddUser();
    void displayEditUser();
    void displayDeleteUser();


private:
    QTableView* mUsersList;
    QLineEdit* mFilter;

    UserListViewModel* mUserListViewModel;

};

#endif // USERSLISTWIDGET_H
