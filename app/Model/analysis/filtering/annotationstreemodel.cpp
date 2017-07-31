#include <QDebug>
#include <QtNetwork>
#include "annotationstreemodel.h"
#include "annotationstreeitem.h"
#include "Model/request.h"



AnnotationsTreeModel::AnnotationsTreeModel(int refId) : TreeModel(0)
{
    mRefId = refId;
    QList<QVariant> rootData;
    rootData << "Name" << "Version" << "Description";
    mRootItem = new TreeItem(rootData);

    refresh();
}




void AnnotationsTreeModel::refresh()
{
    setIsLoading(true);

    Request* req = Request::get(QString("/annotation/%1").arg(mRefId));
    connect(req, &Request::responseReceived, [this, req](bool success, const QJsonObject& json)
    {
        if (success)
        {
            clear();
            QJsonObject data = json["data"].toObject();
            mRefName = data["ref_name"].toString();

            beginResetModel();
            setupModelData(data["db"].toArray(), mRootItem);
            endResetModel();
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Request error ! " ; //<< json["msg"].toString();
        }
        req->deleteLater();
    });
}


Annotation* AnnotationsTreeModel::getAnnotation(QString uid)
{
    if (mAnnotations.contains(uid))
    {
        return mAnnotations[uid];
    }
    else
    {
        return nullptr;
    }
}



QHash<int, QByteArray> AnnotationsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[VersionRole] = "version";
    roles[DescriptionRole] = "description";
    return roles;
}



QVariant AnnotationsTreeModel::newAnnotationsTreeViewItem(QString id, const QVariant& value)
{
    AnnotationsTreeItem *t = new AnnotationsTreeItem(this);
    t->setValue(value);
    t->setUid(id);
    QVariant v;
    v.setValue(t);
    return v;
}

void AnnotationsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    foreach (const QJsonValue dbv, data)
    {
        QJsonObject db = dbv.toObject();


        QString dbName = db["name"].toString();
        QString dbDescription = db["description"].toString();
        QJsonObject dbVersion = db["version"].toObject();

        // qDebug() << "Annotation database : " << dbName;

        // dbVersion.keys();
        // TODO : version sublevel
        QString dbUid = dbVersion[""].toString();

        // Create DB entry
        QList<QVariant> dbColData;
        dbColData << newAnnotationsTreeViewItem(dbUid, QVariant(dbName));
        dbColData << newAnnotationsTreeViewItem(dbUid, QVariant(dbVersion[""]));
        dbColData << newAnnotationsTreeViewItem(dbUid, QVariant(dbDescription));
        TreeItem* dbItem = new TreeItem(dbColData, parent);
        parent->appendChild(dbItem);

        foreach(const QJsonValue json, db["fields"].toArray())
        {
            QJsonObject a = json.toObject();

            QString uid = a["uid"].toString();
            QString dbUid = a["dbuid"].toString();
            QString name = a["name"].toString();
            QString description = a["description"].toString();
            QString type = a["type"].toString();
            QString meta = a["meta"].toString();
            Annotation* annot = new Annotation(this, uid, dbUid, name, description, type, meta, "");

            mAnnotations.insert(uid, annot);

            QList<QVariant> annotColData;
            annotColData << newAnnotationsTreeViewItem(uid, QVariant(name));
            annotColData << newAnnotationsTreeViewItem(uid, QVariant(dbVersion[""]));
            annotColData << newAnnotationsTreeViewItem(uid, QVariant(description));
            TreeItem* annotItem = new TreeItem(annotColData, dbItem);
            dbItem->appendChild(annotItem);

            // qDebug() << " - " << name << "(" << type << ", " << uid << ")";
        }
    }
    qDebug() << "Annotations Model Ready";
}
