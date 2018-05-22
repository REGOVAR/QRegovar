#include "event.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"

QHash<QString, QString> Event::mTypeIconMap = Event::initTypeIconMap();
QHash<QString, QString> Event::initTypeIconMap()
{
    QHash<QString, QString> map;
    map.insert("custom",  "A");
    map.insert("info", "k");
    map.insert("warning",  "m");
    map.insert("error", "l");
    map.insert("technical", "d");

    return map;
}


Event::Event(QObject* parent) : QObject(parent)
{
    connect(this, &Event::dataChanged, this, &Event::updateSearchField);
}

Event::Event(int id, QObject* parent) : Event(parent)
{
    mId = id;
}

Event::Event(QJsonObject json, QObject* parent) : Event(parent)
{
    loadJson(json);
}


void Event::updateSearchField()
{
    mSearchField = mMessage + " " + mDetails + " " + mType;
    if (mAuthor != nullptr)
    {
        mSearchField +=  " " + mAuthor->lastname() + " " + mAuthor->lastname();
    }
    // TODO: do the same for all optional related objects
}



bool Event::loadJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mType = json["type"].toString();
    mMessage = json["message"].toString();
    mDate = QDateTime::fromString(json["date"].toString(), Qt::ISODate);
    mMessageUI.insert("icon", mTypeIconMap[mType]);
    mMessageUI.insert("message", mMessage);

    if (json.contains("details"))
    {
        mDetails = json["details"].toString();
    }
    if (json["meta"].isObject())
    {
        QJsonObject meta = json["meta"].toObject();
        for (QString key: meta.keys())
        {
            if (key == "user_id")
            {
                // TODO
            }
            else if (key == "project_id")
            {
                mProject = regovar->projectsManager()->getOrCreateProject(meta[key].toInt());
            }
            else if (key == "analysis_id")
            {
                mAnalysis = (Analysis*) regovar->analysesManager()->getOrCreateFilteringAnalysis(meta[key].toInt());
            }
            else if (key == "job_id")
            {
                mAnalysis = (Analysis*) regovar->analysesManager()->getOrCreatePipelineAnalysis(meta[key].toInt());
            }
            else if (key == "panel_id")
            {
                mPanel = regovar->panelsManager()->getOrCreatePanel(meta[key].toString());
            }
            else if (key == "subject_id")
            {
                mSubject = regovar->subjectsManager()->getOrCreateSubject(meta[key].toInt());
            }
            else if (key == "sample_id")
            {
                mSample = regovar->samplesManager()->getOrCreateSample(meta[key].toInt());
            }
            else if (key == "file_id")
            {
                mFile = regovar->filesManager()->getOrCreateFile(meta[key].toInt());
            }
        }
    }
    emit dataChanged();
    return true;
}


QJsonObject Event::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("type", mType);
    result.insert("message", mMessage);
    result.insert("date", mDate.toString(Qt::ISODate));
    // meta data
    QJsonObject meta;
    if (mUser != nullptr)
    {
        //meta.insert("user_id", mUser->id());
    }
    if (mProject != nullptr)
    {
        meta.insert("project_id", mProject->id());
    }
    if (mAnalysis != nullptr)
    {
        meta.insert("analysis_id", mAnalysis->id());
    }
    if (mAnalysis != nullptr)
    {
        meta.insert("job_id", mAnalysis->id());
    }
    if (mPanel != nullptr)
    {
        meta.insert("panel_id", mPanel->id());
    }
    if (mSubject != nullptr)
    {
        meta.insert("subject_id", mSubject->id());
    }
    if (mSample != nullptr)
    {
        meta.insert("sample_id", mSample->id());
    }
    if (mFile != nullptr)
    {
        meta.insert("file_id", mFile->id());
    }
    result.insert("meta", meta);


    return result;
}


void Event::save()
{
    if (mId == -1) return;
    Request* request = Request::put(QString("/subject/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Event saved";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}


void Event::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/event/%1").arg(mId));
        connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
        {
            if (success)
            {
                loadJson(json["data"].toObject());
            }
            else
            {
                regovar->manageServerError(json, Q_FUNC_INFO);
            }
            req->deleteLater();
        });
    }
}
