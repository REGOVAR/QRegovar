#include "user.h"

User::User()
{
}

User::User(quint32 id, const QString& firstname, const QString& lastname)
    :mId(id), mFirstname(firstname), mLastname(lastname)
{

}



// Tools ========================================



bool User::isValid() const
{
    return mId != -1;
}









// Properties ========================================



// Property : Id
quint32 User::id() const
{
    return mId;
}
void User::setId(quint32 id)
{
    mId = id;
}


// Property : Lastname
const QString& User::lastname() const
{
    return mLastname;
}
void User::setLastname(const QString& lastname)
{
    mLastname = lastname;
}


// Property : Firstname
const QString& User::firstname() const
{
    return mFirstname;
}
void User::setFirstname(const QString& firstname)
{
    mFirstname = firstname;
}


// Property : Email
const QString& User::email() const
{
    return mEmail;
}
void User::setEmail(const QString& email)
{
    mEmail = email;
}


// Property : Login
const QString& User::login() const
{
    return mLogin;
}
void User::setLogin(const QString& login)
{
    mLogin = login;
}


// Property : Avatar
const QPixmap& User::avatar() const
{
    return mAvatar;
}
void User::setAvatar(const QPixmap& avatar)
{
    mAvatar = avatar;
}


// Property : Function
const QString& User::function() const
{
    return mFunction;
}
void User::setFunction(const QString& function)
{
    mFunction = function;
}


// Property : Location
const QString& User::location() const
{
    return mLocation;
}
void User::setLocation(const QString& location)
{
    mLocation = location;
}


// Property : LastActivity
const QDate& User::lastActivity() const
{
    return mLastActivity;
}
void User::setLastActivity(const QDate& lastActivity)
{
    mLastActivity = lastActivity;
}
