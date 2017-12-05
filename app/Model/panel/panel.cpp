#include "panel.h"
#include "Model/regovar.h"
#include "Model/framework/request.h"

Panel::Panel(QObject* parent) : QObject(parent)
{}

Panel::Panel(int id, QObject* parent) : QObject(parent)
{
    mId = id;
}





bool Panel::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mName = json["name"].toString();
    mOwner = json["owner"].toString();
    mDescription = json["description"].toString();
    mShared = json["shared"].toBool();
    mCreationDate = QDateTime::fromString(json["creation_date"].toString());
    mUpdateDate = QDateTime::fromString(json["update_date"].toString());
    // Versions
    // Entries

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

    return result;
}





void Panel::save()
{
    if (mId == -1) return;
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
