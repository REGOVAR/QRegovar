#include "admin.h"
#include "regovar.h"
#include "framework/request.h"

AdminTableInfo::AdminTableInfo(QObject* parent) : QObject(parent) {}
AdminTableInfo::AdminTableInfo(QJsonObject json, QObject* parent) : QObject(parent)
{
    mSection = json["section"].toString();
    mTable = json["name"].toString();
    mDescription = json["desc"].toString();
    mCount = json["count"].toInt();
    mSize = json["size"].toInt();
    mRealSize = json["totalsize"].toInt();
    mClearable = mTable.startsWith("wt_");
}




Admin::Admin(QObject *parent) : QObject(parent) {}




void Admin::getServerStatus()
{
    Request* req = Request::get(QString("/admin/stats"));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            QJsonObject data = json["data"].toObject();

            mTables.clear();
            mSectionsSizes.clear();
            mWtTables.clear();
            mTablesTotalSize = 0;
            QHash<QString, int> sectionsSizes;
            for (const QJsonValue& value: data["database"].toArray())
            {
                AdminTableInfo* info = new AdminTableInfo(value.toObject());
                mTables.append(info);
                mTablesTotalSize += info->realSize();
                sectionsSizes[info->section()] += info->realSize();
            }
            for (const QJsonValue& value: data["database_tmp"].toArray())
            {
                QJsonObject wt = value.toObject();
                wt.insert("hSize", regovar->formatFileSize(wt["size"].toInt()));
                mWtTables.append(wt);
            }
            for (const QString& k: sectionsSizes.keys())
            {
                QJsonObject json;
                json.insert("section", k);
                json.insert("size", sectionsSizes[k]);
                json.insert("percent", QString::number(sectionsSizes[k] / ((float) mTablesTotalSize) * 100, 'f', 1) + "%");
                json.insert("hSize", regovar->formatFileSize(sectionsSizes[k]));
                if (k == "Regovar")
                {
                    mSectionsSizes.insert(0, json);
                }
                else
                {
                    mSectionsSizes.append(json);
                }
            }

            emit tablesChanged();


            setServerStatus(data);
            qDebug() << "Server status refreshed";
        }
        else
        {
            regovar->manageRequestError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}

void Admin::refreshServerStatus()
{
    // TODO
}


void Admin::clearWt(int analysisId)
{
    Request* req = Request::get(QString("/analysis/%1/clear_temps_data").arg(analysisId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            getServerStatus(); // TODO : replace by refreshServerStatus()
        }
        else
        {
            regovar->manageRequestError(json, Q_FUNC_INFO);
        }
        req->deleteLater();
    });
}
