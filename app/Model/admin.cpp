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
    mRealSize = json["extsize"].toInt();
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
            foreach (QJsonValue value, data["database"].toArray())
            {
                mTables.append(new AdminTableInfo(value.toObject()));
            }
            // TODO : Parse table and proc list
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
