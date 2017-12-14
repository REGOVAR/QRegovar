#include "panel.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

Panel::Panel(QObject* parent) : QObject(parent)
{}

Panel::Panel(QString id, QObject* parent) : QObject(parent)
{
    mId = id;
}





bool Panel::fromJson(QJsonObject json)
{
    mId = json["id"].toString();
    mName = json["name"].toString();
    mOwner = json["owner"].toString();
    mDescription = json["description"].toString();
    mShared = json["shared"].toBool();
    mCreationDate = QDateTime::fromString(json["creation_date"].toString(), Qt::ISODate);
    mUpdateDate = QDateTime::fromString(json["update_date"].toString(), Qt::ISODate);
    // Versions
    mOrderedVersionsId.clear();
    mEntries.clear();
    for (QJsonValue vv: json["versions"].toArray())
    {
        PanelVersion* pv = new PanelVersion(vv.toObject(), this);
        mEntries.insert(pv->id(), pv);
        mOrderedVersionsId.append(pv->id());
    }

    emit dataChanged();

    return true;
}

QJsonObject Panel::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("name", mName);
    result.insert("owner", mOwner);
    result.insert("description", mDescription);
    result.insert("shared", mShared);


    // Versions
    // Notice: json export is used only for Update and Create one version of the panel
    // So, we don't format json with the list of all available version as done server side
    result.insert("version", mCurrentVersion);
    QJsonArray entries;

    for(const QVariant& value: mCurrentEntries)
    {
        entries.append(value.toJsonObject());
    }
    result.insert("entries", entries);

    return result;
}





void Panel::save()
{
    if (mId.isEmpty()) return;
    Request* request = Request::put(QString("/panel/%1").arg(mId), QJsonDocument(toJson()).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Panel saved";
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        request->deleteLater();
    });
}



void Panel::load()
{
    Request* req = Request::get(QString("/panel/%1").arg(mId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            fromJson(json["data"].toObject());
        }
        else
        {
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}






void Panel::addEntry(QJsonObject data)
{
    mCurrentEntries.append(data);
    emit dataChanged();
}


void Panel::reset()
{
    mName = "";
    mDescription = "";
    mOwner = "";
    mDescription = "";
    mShared = false;
    mCurrentVersion = "";
    mCurrentEntries.clear();
    emit dataChanged();
}





