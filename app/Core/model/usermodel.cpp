#include "usermodel.h"

UserModel::UserModel(QObject* parent) : ResourceModel(parent)
{
}

UserModel::UserModel(quint32 id, const QString& firstname, const QString& lastname, QObject* parent)
    : ResourceModel(id, parent), mFirstname(firstname), mLastname(lastname)
{
}



// Tools ========================================




bool UserModel::fromJson(QJsonDocument json)
{
    // TODO set current user with json data
    // QString st(json.toJson(QJsonDocument::Compact));
    mId = 1;
    mFirstname = "Olivier";
    mLastname = "Gueudelot";
    emit resourceChanged();
    emit userChanged();
    return true;
}

void UserModel::clear()
{
    mId = -1;
    mFirstname = tr("Anonymous");
    mLastname = tr("Anonymous");
    mEmail = "";
    mLogin = "";
    mPassword = "";
    // TODO : mAvatar; empty qpixmap ?
    mFunction = "";
    mLocation = "";
    emit resourceChanged();
    emit userChanged();
}









// Properties ========================================


// Property : Lastname
const QString& UserModel::lastname() const
{
    return mLastname;
}
void UserModel::setLastname(const QString& lastname)
{
    mLastname = lastname;
    emit resourceChanged();
    emit userChanged();
}


// Property : Firstname
const QString& UserModel::firstname() const
{
    return mFirstname;
}
void UserModel::setFirstname(const QString& firstname)
{
    mFirstname = firstname;
    emit resourceChanged();
    emit userChanged();
}


// Property : Email
const QString& UserModel::email() const
{
    return mEmail;
}
void UserModel::setEmail(const QString& email)
{
    mEmail = email;
    emit resourceChanged();
    emit userChanged();
}


// Property : Login
const QString& UserModel::login() const
{
    return mLogin;
}
void UserModel::setLogin(const QString& login)
{
    mLogin = login;
    emit resourceChanged();
    emit userChanged();
}


// Property : Password
const QString& UserModel::password() const
{
    return mPassword;
}
void UserModel::setPassword(const QString& password)
{
    mPassword = password;
    emit resourceChanged();
    emit userChanged();
}


// Property : Avatar
const QPixmap& UserModel::avatar() const
{
    return mAvatar;
}
void UserModel::setAvatar(const QPixmap& avatar)
{
    mAvatar = avatar;
    emit resourceChanged();
    emit userChanged();
}


// Property : Function
const QString& UserModel::function() const
{
    return mFunction;
}
void UserModel::setFunction(const QString& function)
{
    mFunction = function;
    emit resourceChanged();
    emit userChanged();

}


// Property : Location
const QString& UserModel::location() const
{
    return mLocation;
}
void UserModel::setLocation(const QString& location)
{
    mLocation = location;
    emit resourceChanged();
    emit userChanged();
}


// Property : LastActivity
const QDate& UserModel::lastActivity() const
{
    return mLastActivity;
}
void UserModel::setLastActivity(const QDate& lastActivity)
{
    mLastActivity = lastActivity;
    emit resourceChanged();
    emit userChanged();
}
