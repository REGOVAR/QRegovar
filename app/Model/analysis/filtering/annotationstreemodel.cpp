#include <QDebug>
#include <QtNetwork>
#include "annotationstreemodel.h"
#include "Model/framework/treeitem.h"
#include "Model/framework/request.h"



AnnotationsTreeModel::AnnotationsTreeModel(QObject* parent) : TreeModel(parent)
{
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    for (const int roleId: roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);
}





bool AnnotationsTreeModel::fromJson(QJsonObject data, QStringList dbUids)
{
    // TODO : manage error
    clear();
    mRefId = data["ref_id"].toInt();
    mRefName = data["ref_name"].toString();

    beginResetModel();
    setupModelData(data["db"].toArray(), mRootItem, dbUids);
    endResetModel();

    qDebug() << "Annotation loaded for ref" << mRefName << ":" << mAnnotations.count();
    return true;
}


Annotation* AnnotationsTreeModel::getAnnotation(const QModelIndex &index)
{
    TreeItem* item = getItem(index);
    if (item != nullptr)
    {
        return getAnnotation(item->data(IdRole).toString());
    }
    return nullptr;
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
    roles[IdRole] = "id";
    roles[CheckedRole] = "Checked";
    roles[NameRole] = "name";
    roles[VersionRole] = "version";
    roles[DescriptionRole] = "description";
    return roles;
}








void AnnotationsTreeModel::setupModelData(QJsonArray data, TreeItem *parent, QStringList dbUids)
{
    for (const QJsonValue& dbv: data)
    {
        QJsonObject db = dbv.toObject();

        QString dbName = db["name"].toString();
        QString dbDescription = db["description"].toString();
        QJsonObject dbVersion = db["version"].toObject();


        // Version sublevel
        for (const QString& dbUid: dbVersion.keys())
        {
            // Keep only annotations used in the analyses
            if (dbUids.contains(dbUid) || (dbUid == "" && dbName == "Variant"))
            {
                // Create DB entry
                QHash<int, QVariant> dbColData;
                dbColData.insert(IdRole, QVariant(dbUid));
                dbColData.insert(CheckedRole, QVariant(false));
                dbColData.insert(NameRole, QVariant(dbName));
                dbColData.insert(VersionRole, QVariant(dbVersion[""]));
                dbColData.insert(DescriptionRole, QVariant(dbDescription));
                TreeItem* dbItem = new TreeItem(dbColData, parent);
                parent->appendChild(dbItem);

                for (const QJsonValue& json: db["fields"].toArray())
                {
                    QJsonObject a = json.toObject();

                    QString uid = a["uid"].toString();
                    QString name = a["name"].toString();
                    QString description = a["description"].toString();
                    QString type = a["type"].toString();
                    QJsonObject meta = a["meta"].toObject();
                    Annotation* annot = new Annotation(this, uid, dbUid, name, description, type, meta, dbName, dbVersion[""].toString());

                    mAnnotations.insert(uid, annot);

                    QHash<int, QVariant> annotColData;
                    dbColData.insert(IdRole, QVariant(uid));
                    dbColData.insert(CheckedRole, QVariant(false));
                    annotColData.insert(NameRole, QVariant(name));
                    annotColData.insert(VersionRole, QVariant(dbVersion[""]));
                    annotColData.insert(DescriptionRole, QVariant(description));
                    TreeItem* annotItem = new TreeItem(annotColData, dbItem);
                    dbItem->appendChild(annotItem);

                    // qDebug() << " - " << name << "(" << type << ", " << uid << ")";
                }
            }
        }
    }
    qDebug() << "Annotations Model Ready";
}



void AnnotationsTreeModel::addEntry(QString dbName, QString dbVersion, QString dbDescription, bool isDbSelected, FieldColumnInfos* data)
{
    QString fullName = dbName;
    QString dbUid = data->annotation()->dbUid();
    if (dbVersion != "_regovar_")
    {
        fullName += " (" + dbVersion + ")";
    }

    TreeItem* parentDB = nullptr;

    // Retrieve root item for the annotation db
    for(int idx=0; idx < mRootItem->childCount(); idx++)
    {
        TreeItem* item = mRootItem->child(idx);
        QString itemDbName = item->data(NameRole).toString();
        if (fullName == itemDbName)
        {
            parentDB = item;
            break;
        }
    }

    if (parentDB == nullptr)
    {
        // Create DB entry
        QHash<int, QVariant> dbColData4Db;
        dbColData4Db.insert(IdRole, QVariant(dbUid));
        dbColData4Db.insert(CheckedRole, QVariant(isDbSelected));
        dbColData4Db.insert(NameRole, QVariant(fullName));
        dbColData4Db.insert(VersionRole, QVariant(dbVersion));
        dbColData4Db.insert(DescriptionRole, QVariant(dbDescription));

        parentDB = new TreeItem(dbColData4Db, mRootItem);
        mRootItem->appendChild(parentDB);
    }

    if (isDbSelected)
    {
        // todo
    }

    // create fields entry
    QString uid = data->annotation()->uid();
    mAnnotations.insert(uid, data->annotation()); // need that ?

    QHash<int, QVariant> annotColData;
    annotColData.insert(IdRole, QVariant(uid));
    annotColData.insert(CheckedRole, QVariant(data->isDisplayed()));
    annotColData.insert(NameRole, QVariant(data->annotation()->name()));
    annotColData.insert(DescriptionRole, QVariant(data->annotation()->description()));
    TreeItem* annotItem = new TreeItem(annotColData, parentDB);
    parentDB->appendChild(annotItem);
}
