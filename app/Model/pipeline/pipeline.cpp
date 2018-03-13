#include "pipeline.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"


Pipeline::Pipeline(QObject* parent) : QObject(parent)
{
    connect(this, &Pipeline::dataChanged, this, &Pipeline::updateSearchField);
}

Pipeline::Pipeline(int id, QObject* parent) : QObject(parent)
{
    connect(this, &Pipeline::dataChanged, this, &Pipeline::updateSearchField);
    mId = id;
}

Pipeline::Pipeline(QJsonObject json) : QObject(nullptr)
{
    connect(this, &Pipeline::dataChanged, this, &Pipeline::updateSearchField);
    fromJson(json);
}


void Pipeline::updateSearchField()
{
    mSearchField = mName + " " + mVersion + " " + mPirusApiVersion + " " + mStatus + " " + mType + " " + mDescription;
    if (mAuthors.count() > 0)
    {
        mSearchField += " " + mAuthors.join(" ");
    }
}



bool Pipeline::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mType = json["type"].toString();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mStatus = json["status"].toString();
    mVersion = json["version"].toString();
    mStarred = json["starred"].toBool();
    mInstallationDate = QDateTime::fromString(json["installation_date"].toString(), Qt::ISODate);
    emit dataChanged();
}



void Pipeline::install()
{
    if (mId == -1) return;
    Request* request = Request::get(QString("/pipeline/install/%1/%2").arg(mId).arg(mType));
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            qDebug() << "Pipeline installed";
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


void Pipeline::load(bool forceRefresh)
{
    // Check if need refresh
    qint64 diff = mLastInternalLoad.secsTo(QDateTime::currentDateTime());
    if (forceRefresh || diff > MIN_SYNC_DELAY)
    {
        mLastInternalLoad = QDateTime::currentDateTime();
        Request* req = Request::get(QString("/pipeline/%1").arg(mId));
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
}
