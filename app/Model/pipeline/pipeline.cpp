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
    fromJson(json);
}


void Pipeline::updateSearchField()
{
    mSearchField = mName + " " + mVersion + " " + mVersionApi + " " + mStatus + " " + mType + " " + mDescription;
    // TODO: adding manifest information like developpers ?
}



bool Pipeline::fromJson(QJsonObject json)
{
    mId = json["id"].toInt();
    mType = json["type"].toString();
    mName = json["name"].toString();
    mDescription = json["description"].toString();
    mStatus = json["status"].toString();
    mVersion = json["version"].toString();
    mVersionApi = json["version_api"].toString();
    mStarred = json["starred"].toBool();
    mInstallationDate = QDateTime::fromString(json["installation_date"].toString(), Qt::ISODate);
    mManifestJson = json["manifest"].toObject();

    QJsonObject docs = json["documents"].toObject();
    for (const QString k: docs.keys())
    {
        if (k == "form") mForm = QUrl(docs[k].toString());
        else if (k == "icon") mIcon = QUrl(docs[k].toString());
        else if (k == "license") mLicense = QUrl(docs[k].toString());
        else if (k == "readme") mReadme = QUrl(docs[k].toString());
        else if (k == "help") mHelpPage = QUrl(docs[k].toString());
        else if (k == "home") mHomePage = QUrl(docs[k].toString());
        else if (k == "manifest") mManifest = QUrl(docs[k].toString());
    }

    updateSearchField();
    emit dataChanged();
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
    docs.insert("home", mHomePage.toString());
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


