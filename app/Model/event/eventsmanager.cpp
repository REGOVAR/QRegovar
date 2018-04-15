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
        event->fromJson(data);
        if (data["type"] != "technical")
        {
            mLastEvents->add(event);
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
//    // Retrieve realtime progress data
//    QString status = data["status"].toString();
//    double progressValue = 0.0;
//    if (action == "import_vcf_processing" || action == "import_vcf_start")
//    {
//        progressValue = data["progress"].toDouble();
//    }
//    else if (action == "import_vcf_end")
//    {
//        progressValue = 1.0;
//        status = "ready";
//    }

//    // Update sample status
//    for (const QJsonValue& json: data["samples"].toArray())
//    {
//        QJsonObject obj = json.toObject();
//        int sid = obj["id"].toInt();

//        Sample* sample = getOrCreateEvent(sid);
//        sample->setStatus(status);
//        sample->setLoadingProgress(progressValue);
//        sample->refreshUIAttributes();
//    }

//    // Notify view when new sample import start (import wizard)
//    if (action == "import_vcf_start")
//    {
//        QList<int> ids;
//        for (QJsonValue sample: data["samples"].toArray())
//        {
//            QJsonObject sampleData = sample.toObject();
//            ids << sampleData["id"].toInt();
//        }
//        emit sampleImportStart(data["file_id"].toString().toInt(), ids);
//    }
}
