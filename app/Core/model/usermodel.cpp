#include "usermodel.h"

UserModel::UserModel(QObject* parent)
    :QObject(parent)
{
}

UserModel::UserModel(quint32 id, const QString& firstname, const QString& lastname, QObject* parent)
    :QObject(parent),mId(id), mFirstname(firstname), mLastname(lastname)
{

}



// Tools ========================================



bool UserModel::isValid() const
{
    return mId != -1;
}

bool UserModel::fromJson(QJsonDocument json)
{
    // TODO set current user with json data
    // QString st(json.toJson(QJsonDocument::Compact));
    mId = 1;
    mFirstname = "Olivier";
    mLastname = "Gueudelot";
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
    emit userChanged();
}









// Properties ========================================



// Property : Id


quint32 UserModel::id() const
{
    return mId;
}
void UserModel::setId(quint32 id)
{
    mId = id;
    emit userChanged();
}


// Property : Lastname
const QString& UserModel::lastname() const
{
    return mLastname;
}
void UserModel::setLastname(const QString& lastname)
{
    mLastname = lastname;
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
    emit userChanged();

}
