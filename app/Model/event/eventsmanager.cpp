#include "eventsmanager.h"

EventsManager::EventsManager(QObject *parent) : QObject(parent)
{
    mLastEvents = new EventsListModel(this);
    mTechnicalEvents = new EventsListModel(this);
}



void EventsManager::loadJson(QJsonArray json)
{
    for (const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        int id = data["id"].toInt();
        Event* event = getOrCreateEvent(id);
        event->loadJson(data);
        if (data["type"] != "technical")
        {
            mLastEvents->append(event);
        }

        // mTechnicalEvents->add(event);
    }

}





Event* EventsManager::getOrCreateEvent(int eventId)
{
    if (mEvents.contains(eventId))
    {
        return mEvents[eventId];
    }
    // else
    Event* newEvent = new Event(eventId, this);
    mEvents.insert(eventId, newEvent);
    return newEvent;
}


void EventsManager::processPushNotification(QString action, QJsonObject data)
{
    if (action == "new_event")
    {
        Event* newEvent = getOrCreateEvent(data["id"].toInt());
        newEvent->loadJson(data);

        if (newEvent->type() != "technical")
        {
            mLastEvents->append(newEvent);
            emit lastEventsChanged();
        }
        mTechnicalEvents->append(newEvent);
        emit technicalEventsChanged();
        emit newEventPop(newEvent);
    }
}
