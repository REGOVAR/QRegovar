#ifndef USEREDITINGDIALOG_H
#define USEREDITINGDIALOG_H

#include <QWidget>
#include <QDialog>
#include <QLineEdit>
#include <QLabel>
#include <QDialogButtonBox>

#include "model/usermodel.h"

class UserEditingDialog : public QDialog
{
    Q_OBJECT
public:
    explicit UserEditingDialog(UserModel* user, QWidget *parent = 0);

public Q_SLOTS:
    void save();
    void checkLogin();
    void checkEmail();
    void randomPassword();
    void selectAvatar();

private:
    QLineEdit* mLogin;
    QLineEdit* mPassword;
    QLineEdit* mFirstname;
    QLineEdit* mLastname;
    QLineEdit* mFunction;
    QLineEdit* mEmail;
    QLineEdit* mLocation;
    QLabel* mAvatar;
    QDialogButtonBox * mButtonBox;

    UserModel* mUser;

};

#endif // USEREDITINGDIALOG_H
