#include "pipeline.h"
#include "Model/framework/request.h"
#include "Model/regovar.h"


Pipeline::Pipeline(QObject* parent) : QObject(parent)
{
    mConfigForm = new DynamicFormModel(this);
    connect(this, &Pipeline::dataChanged, this, &Pipeline::updateSearchField);
}

Pipeline::Pipeline(int id, QObject* parent) : Pipeline(parent)
{
    mId = id;
}

Pipeline::Pipeline(QJsonObject json) : Pipeline(nullptr)
{
    loadJson(json);
}


void Pipeline::updateSearchField()
{
    mSearchField = mName + " " + mVersion + " " + mVersionApi + " " + mStatus + " " + mType + " " + mDescription;
    // TODO: adding manifest information like developpers ?
}



bool Pipeline::loadJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mType = json["type"].toString();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mStatus = json["status"].toString();
    mVersion = json["version"].toString();
    mStarred = json["starred"].toBool();
    mInstallationDate = QDateTime::fromString(json["installation_date"].toString(), Qt::ISODate);
    mManifestJson = json["manifest"].toObject();

    QJsonObject docs = json["documents"].toObject();


    for (const QString k: docs.keys())
    {
        if (k == "form" && !docs[k].isNull()) mForm = QUrl(docs[k].toString());
        else if (k == "icon" && !docs[k].isNull()) mIcon = QUrl(docs[k].toString());
        else if (k == "license" && !docs[k].isNull()) mLicense = QUrl(docs[k].toString());
        else if (k == "readme" && !docs[k].isNull()) mReadme = QUrl(docs[k].toString());
        else if (k == "help" && !docs[k].isNull()) mHelpPage = QUrl(docs[k].toString());
        else if (k == "about" && !docs[k].isNull()) mAboutPage = QUrl(docs[k].toString());
    }

    updateSearchField();
    emit dataChanged();
    return true;
}


QJsonObject Pipeline::toJson()
{
    QJsonObject result;
    // Simples data
    result.insert("id", mId);
    result.insert("type", mType);
    result.insert("name", mName);
    result.insert("version", mVersion);
    result.insert("type", mType);
    result.insert("status", mStatus);
    result.insert("starred", mStarred);
    result.insert("installation_date", mInstallationDate.toString(Qt::ISODate));
    result.insert("manifest", mManifestJson);
    QJsonObject docs;
    docs.insert("form", mForm.toString());
    docs.insert("icon", mIcon.toString());
    docs.insert("license", mLicense.toString());
    docs.insert("readme", mReadme.toString());
    docs.insert("help", mHelpPage.toString());
    docs.insert("home", mAboutPage.toString());
    result.insert("documents", docs);
    return result;
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
            regovar->manageServerError(json, Q_FUNC_INFO);
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


