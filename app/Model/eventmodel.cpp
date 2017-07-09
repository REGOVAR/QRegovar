#include "eventmodel.h"

EventModel::EventModel(QObject* parent) : ResourceModel(parent)
{
}
EventModel::EventModel(quint32 id, QDateTime date, EventType type, QString message, UserModel* user, QObject* parent)
    : ResourceModel(id, parent)
{
    mDate = date;
    mType = type;
    mMessage = message;
    mUser = user;
}








// Methods to override
bool EventModel::fromJson(QJsonDocument json)
{
    // TODO
}

void EventModel::clear()
{
    delete mUser;
}







// Property : Date
const QDateTime& EventModel::date() const
{
    return mDate;
}
void EventModel::setDate(const QDateTime& date)
{
    mDate = date;
    emit resourceChanged();
}

// Property : Message
const QString& EventModel::message() const
{
    return mMessage;
}
void EventModel::setMessage(const QString& message)
{
    mMessage = message;
    emit resourceChanged();
}

// Property : User
UserModel* EventModel::user() const
{
    return mUser;
}
void EventModel::setUser(UserModel* user)
{
    mUser = user;
    emit resourceChanged();
}

// Property : Type

const EventType& EventModel::type() const
{
    return mType;
}
void EventModel::setUser(const EventType& type)
{
    mType = type;
    emit resourceChanged();
}
