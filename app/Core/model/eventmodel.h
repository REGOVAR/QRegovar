#ifndef EVENTMODEL_H
#define EVENTMODEL_H

#include <QtCore>

#include "resourcemodel.h"
#include "usermodel.h"


enum EventType
{
    Info = 0,
    Warning,
    Error,
    Success
};

/*!
 * \brief Define a Regovar Event.
 */
class EventModel : public ResourceModel
{
public:
    // Constructor
    EventModel(QObject* parent=nullptr);
    EventModel(quint32 id, QDateTime date, EventType type, QString message, UserModel* user, QObject* parent=nullptr);

    // Properties
    // Read
    const QDateTime& date() const;
    const QString& message() const;
    const EventType& type() const;
    UserModel* user() const;
    // Write
    void setDate(const QDateTime& date);
    void setMessage(const QString& message);
    void setUser(UserModel* user);
    void setUser(const EventType& type);

    // Methods to override
    bool fromJson(QJsonDocument json);
    void clear();

private:
    QDateTime mDate;
    QString mMessage;
    UserModel* mUser;
    EventType mType;
};

#endif // EVENTMODEL_H
