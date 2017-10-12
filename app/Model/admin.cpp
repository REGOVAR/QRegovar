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
            QHash<QString, QJsonObject> wtData;
            foreach (QJsonValue value, data["database"].toArray())
            {
                AdminTableInfo* info = new AdminTableInfo(value.toObject());
                mTables.append(info);
                mTablesTotalSize += info->realSize();
                // compute total sizes by sections
                if (info->table().startsWith("wt_"))
                {
                    QString wtname = info->table().mid(0, info->table().indexOf("_", 3));
                    if (!wtData.contains(wtname))
                    {
                        QJsonObject data;
                        data.insert("label", wtname);
                        data.insert("size", 0);
                        wtData.insert(wtname, data);
                    }
                    //wtData[wtname]["size"] = QJsonValue(QVariant::fromValue(wtData[wtname]["size"]).toInt() + info->size());
                }
                sectionsSizes[info->section()] += info->realSize();
            }
            foreach (QString k, sectionsSizes.keys())
            {
                QJsonObject json;
                json.insert("section", k);
                json.insert("size", regovar->sizeToHumanReadable(sectionsSizes[k]));
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
            QJsonObject jsonError = json;
            jsonError.insert("method", Q_FUNC_INFO);
            regovar->raiseError(jsonError);
        }
        req->deleteLater();
    });
}

void Admin::refreshServerStatus()
{
}
