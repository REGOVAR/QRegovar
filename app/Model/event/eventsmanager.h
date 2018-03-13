#ifndef EVENTSMANAGER_H
#define EVENTSMANAGER_H

#include <QtCore>
#include "eventslistmodel.h"
#include "event.h"

class EventsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(EventsListModel* lastEvents READ lastEvents NOTIFY lastEventsChanged)
    Q_PROPERTY(EventsListModel* technicalEvents READ technicalEvents NOTIFY technicalEventsChanged)

public:
    explicit EventsManager(QObject* parent=nullptr);

    // Getters
    inline EventsListModel* lastEvents() const { return mLastEvents; }
    inline EventsListModel* technicalEvents() const { return mTechnicalEvents; }

    // Method
    void loadJson(QJsonArray json);
    Event* getOrCreateEvent(int eventId);


Q_SIGNALS:
    void lastEventsChanged();
    void technicalEventsChanged();
    void newEventPop(Event* event);

public Q_SLOTS:
    // Called by NetworkManager when need to process WebSocket messages managed by SampleManager
    void processPushNotification(QString action, QJsonObject data);


private:
    //! List of last events (displayed on welcom page)
    EventsListModel* mLastEvents;
    //! List of last technical events (displayed in admin panels)
    EventsListModel* mTechnicalEvents;
    //! Internal collection of all loaded events
    QHash<qint64, Event*> mEvents;
};

#endif // EVENTSMANAGER_H
