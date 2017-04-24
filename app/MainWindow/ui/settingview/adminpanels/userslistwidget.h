#ifndef USERSLISTWIDGET_H
#define USERSLISTWIDGET_H

#include <QWidget>
#include <QTableView>
#include <QLineEdit>
#include "../abstractsettingswidget.h"


class UsersListWidget : public AbstractSettingsWidget
{
    Q_OBJECT
public:
    explicit UsersListWidget(QWidget *parent = 0);


public Q_SLOTS:
    bool save();
    bool load();
    void onChanged();

private:
    QTableView* mUsersList;
    QLineEdit* mFilter;



};

#endif // USERSLISTWIDGET_H
