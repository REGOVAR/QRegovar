#include "panel.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"



Panel::Panel(bool rootPanel, QObject* parent) : QObject(parent)
{
    if (rootPanel)
    {
        mOrderedVersionsIds = new QStringList();
        mVersionsMap = new QHash<QString, Panel*>();
    }
}

Panel::Panel(QStringList* orderedVersions, QHash<QString, Panel*>* map, QObject* parent) : QObject(parent)
{
    mOrderedVersionsIds = orderedVersions;
    mVersionsMap = map;
}




Panel* Panel::buildPanel(QJsonObject json)
{
    // Create first panel
    Panel* panel = new Panel(true);
    if (panel->loadJson(json))
    {
        // Create all other versions of the same panel
        for (const QJsonValue& data: json["versions"].toArray())
        {
            panel->addVersion(data.toObject(), true);
        }
    }
    return panel;
}














QString Panel::addVersion(QJsonObject data, bool append)
{
    Panel* panel = new Panel(mOrderedVersionsIds, mVersionsMap);
    bool result = panel->loadJson(data);
    if (result)
    {
        mVersionsMap->insert(panel->versionId(), panel);
        if (append)
        {
            mOrderedVersionsIds->append(panel->versionId());
        }
        else
        {
            mOrderedVersionsIds->insert(0, panel->versionId());
        }
    }
    return result ? panel->versionId() : "";
}




// Load only data for the current panelversion.
bool Panel::loadJson(QJsonObject json)
{
    // json may be for Panel or Panel's version
    // a Panel contains a list of version

    if (json.contains("versions"))
    {
        // Loading Panels information
        mOrderedVersionsIds->clear();
        mVersionsMap->clear();

        mPanelId = json["id"].toString();
        mName = json["name"].toString();
        mOwner = json["owner"].toString();
        mDescription = json["description"].toString();
        mShared = json["shared"].toBool();
        mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
        mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

        // Create all other versions of the same panel
        for (const QJsonValue& data: json["versions"].toArray())
        {
            QString versionId = addVersion(data.toObject(), true);
            // Set panelId of the new version created
            regovar->panelsManager()->getOrCreatePanel(versionId)->setPanelId(mPanelId);
        }
    }
    else
    {
        // Load version information
        mVersionId = json["id"].toString();
        mVersion = json["name"].toString();
        mComment = json["comment"].toString();
        mCreateDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
        mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);

        // Load entries
        for(const QJsonValue& entry: json["entries"].toArray())
        {
            // Compute details field
            QJsonObject entryData = entry.toObject();

            if (entryData.contains("id"))
            {
                entryData.insert("details", entryData["id"]);
            }
            else
            {
                entryData.insert("details", QString("Chr%1:%2-%3").arg(entryData["chr"].toInt()).arg(entryData["start"].toInt()).arg(entryData["end"].toInt()));
            }
            mEntries.append(entryData);
        }
    }

    mLoaded = true;
    emit dataChanged();
    return true;
}

QJsonObject Panel::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mPanelId);
    result.insert("name", mName);
    result.insert("owner", mOwner);
    result.insert("description", mDescription);
    result.insert("shared", mShared);


    // Versions
    // Notice: json export is used only for Update and Create one version of the panel
    // So, we don't format json with the list of all available version as done server side
    // Notice: in case of the user only update panel's information, we don't send version
    // data to the server. To avoid to create wrong version
    if (!mVersion.isEmpty())
    {
        result.insert("version", mVersion);
        QJsonArray entries;

        for(const QVariant& value: mEntries)
        {
            entries.append(value.toJsonObject());
        }
        result.insert("entries", entries);
    }
    return result;
}





void Panel::save()
{
    if (mPanelId.isEmpty()) return;
    Request* request = Request::put(QString("/panel/%1").arg(mPanelId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Panel saved";
        }
        else
        {
            regovar->manageServerError(json, Q_FUNC_INFO);
        }
        request->deleteLater();
    });
}



void Panel::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (!mLoaded || forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/panel/%1").arg(mPanelId));
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





void Panel::addEntry(QJsonObject data)
{
    // Check if data already exists in the panel
    bool append = true;
    if (data.contains("id"))
    {
        for(QVariant v: mEntries)
        {
            QJsonObject j = v.toJsonObject();
            if (j.contains("id") && j["id"] == data["id"])
            {
                append = false;
                break;
            }
        }
    }
    else if (data.contains("chr") && data.contains("start") && data.contains("end"))
    {
        for(QVariant v: mEntries)
        {
            QJsonObject j = v.toJsonObject();
            if (j.contains("chr") && j["chr"] == data["chr"])
            {
                if (j["start"] == data["start"] && j["end"] == data["end"])
                {
                    append = false;
                    break;
                }
            }
        }
    }


    if (append)
    {
        mEntries.append(data);
        emit dataChanged();
    }
}


void Panel::reset()
{
    mName = "";
    mDescription = "";
    mOwner = "";
    mDescription = "";
    mShared = false;
    mVersion = "";
    mEntries.clear();
    emit dataChanged();
}





