#include "user.h"

User::User()
{
}

User::User(quint32 id, const QString &firstname, const QString &lastname)
    :mId(id), mFirstname(firstname), mLastname(lastname)
{

}

void User::setId(quint32 id)
{
    mId = id;
}

void User::setLastname(const QString &lastname)
{
    mLastname = lastname;
}

void User::setFirstname(const QString &firstname)
{
    mFirstname = firstname;
}

bool User::isValid() const
{
    return mId != -1;
}

quint32 User::id() const
{
    return mId;
}

const QString& User::lastname() const
{
    return mLastname;
}

const QString& User::firstname() const
{
    return mFirstname;
}

