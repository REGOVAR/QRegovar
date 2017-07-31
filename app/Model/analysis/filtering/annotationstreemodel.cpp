#include <QDebug>
#include <QtNetwork>
#include "annotationstreemodel.h"
#include "annotationstreeitem.h"
#include "Model/request.h"



AnnotationsTreeModel::AnnotationsTreeModel(QObject* parent) : TreeModel(parent)
{
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);
}





bool AnnotationsTreeModel::fromJson(QJsonObject data)
{
    // TODO : manage error
    clear();
    mRefId = data["ref_id"].toInt();;
    mRefName = data["ref_name"].toString();

    beginResetModel();
    setupModelData(data["db"].toArray(), mRootItem);
    endResetModel();

    qDebug() << "Annotation loaded for ref" << mRefName << ":" << mAnnotations.count();
    return true;
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

        // dbVersion.keys();
        // TODO : version sublevel
        QString dbUid = dbVersion[""].toString();

        // Create DB entry
        QHash<int, QVariant> dbColData;
        dbColData.insert(NameRole, newAnnotationsTreeViewItem(dbUid, QVariant(dbName)));
        dbColData.insert(VersionRole, newAnnotationsTreeViewItem(dbUid, QVariant(dbVersion[""])));
        dbColData.insert(DescriptionRole, newAnnotationsTreeViewItem(dbUid, QVariant(dbDescription)));
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

            QHash<int, QVariant> annotColData;
            annotColData.insert(NameRole, newAnnotationsTreeViewItem(uid, QVariant(name)));
            annotColData.insert(VersionRole, newAnnotationsTreeViewItem(uid, QVariant(dbVersion[""])));
            annotColData.insert(DescriptionRole, newAnnotationsTreeViewItem(uid, QVariant(description)));
            TreeItem* annotItem = new TreeItem(annotColData, dbItem);
            dbItem->appendChild(annotItem);

            // qDebug() << " - " << name << "(" << type << ", " << uid << ")";
        }
    }
    qDebug() << "Annotations Model Ready";
}
