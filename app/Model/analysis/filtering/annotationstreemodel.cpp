#include <QDebug>
#include <QtNetwork>
#include "annotationstreemodel.h"
#include "Model/framework/treeitem.h"
#include "Model/framework/request.h"



AnnotationsTreeModel::AnnotationsTreeModel(FilteringAnalysis* analysis) : TreeModel(analysis)
{
    mAnalysis = analysis;
    // With QML TreeView, the rootItem must know all column's roles to allow correct display for
    // other rows. So that's why we create columns for all existings roles.
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    for (const int roleId: roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);


    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Order);
    mProxy->setRecursiveFilteringEnabled(true);
}





bool AnnotationsTreeModel::fromJson(QJsonObject, QStringList)
{
//    NEVER USED ???
//    clear();
//    mRefId = data["ref_id"].toInt();
//    mRefName = data["ref_name"].toString();

//    beginResetModel();
//    setupModelData(data["db"].toArray(), mRootItem, dbUids);
//    endResetModel();

//    qDebug() << "Annotation loaded for ref" << mRefName << ":" << mAnalysis->annotationsMap().count();
    return true;
}


FieldColumnInfos* AnnotationsTreeModel::getAnnotation(const QModelIndex &index)
{
    TreeItem* item = getItem(index);
    if (item != nullptr)
    {
        return getAnnotation(item->data(Id).toString());
    }
    return nullptr;
}


FieldColumnInfos* AnnotationsTreeModel::getAnnotation(QString uid)
{
    if (mAnalysis->annotationsMap().contains(uid))
    {
        return mAnalysis->annotationsMap().value(uid);
    }
    else
    {
        return nullptr;
    }
}



QHash<int, QByteArray> AnnotationsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[DbId] = "dbid";
    roles[Order] = "order";
    roles[Selected] = "selected";
    roles[Name] = "name";
    roles[Version] = "version";
    roles[Description] = "description";
    roles[SearchField] = "searchField";
    return roles;
}








void AnnotationsTreeModel::setupModelData(QJsonArray, TreeItem*, QStringList)
{
//    NEVER USED ???
//    for (const QJsonValue& dbv: data)
//    {
//        QJsonObject db = dbv.toObject();

//        QString dbName = db["name"].toString();
//        QString dbDescription = db["description"].toString();
//        QJsonObject dbVersion = db["version"].toObject();


//        // Version sublevel
//        for (const QString& dbUid: dbVersion.keys())
//        {
//            // Keep only annotations used in the analyses
//            if (dbUids.contains(dbUid) || (dbUid == "" && dbName == "Variant"))
//            {
//                // Create DB entry
//               //addEntry(dbName, dbVersion[""], dbDescription, false, )
//                QHash<int, QVariant> dbColData;
//                dbColData.insert(Id, QVariant(dbUid));
//                dbColData.insert(Checked, QVariant(false));
//                dbColData.insert(Name, QVariant(dbName));
//                dbColData.insert(Version, QVariant(dbVersion[""]));
//                dbColData.insert(Description, QVariant(dbDescription));
//                QString search = dbName + " " + dbDescription + " " + dbVersion[""].toString();
//                dbColData.insert(SearchField,  QVariant(search));
//                TreeItem* dbItem = new TreeItem(dbColData, parent);
//                parent->appendChild(dbItem);

//                for (const QJsonValue& json: db["fields"].toArray())
//                {
//                    QJsonObject a = json.toObject();

//                    QString uid = a["uid"].toString();
//                    QString name = a["name"].toString();
//                    QString description = a["description"].toString();

//                    QHash<int, QVariant> annotColData;
//                    dbColData.insert(Id, QVariant(uid));
//                    dbColData.insert(Checked, QVariant(false));
//                    annotColData.insert(Name, QVariant(name));
//                    annotColData.insert(Version, QVariant(dbVersion[""]));
//                    annotColData.insert(Description, QVariant(description));
//                    QString search2 = name + " " + description + " " + dbName + " " + dbDescription + " " + dbVersion[""].toString();
//                    dbColData.insert(SearchField,  QVariant(search2));
//                    TreeItem* annotItem = new TreeItem(annotColData, dbItem);
//                    dbItem->appendChild(annotItem);

//                    // qDebug() << " - " << name << "(" << type << ", " << uid << ")";
//                }
//            }
//        }
//    }
//    qDebug() << "Annotations Model Ready";
}



void AnnotationsTreeModel::addEntry(QString dbName, QString dbVersion, QString dbDescription, bool isDbSelected, FieldColumnInfos* data)
{
    QString fullName = dbName;
    QString dbUid = data->annotation()->dbUid();
    if (!dbVersion.isEmpty())
    {
        fullName += " (" + dbVersion + ")";
    }

    TreeItem* parentDB = nullptr;

    // Retrieve root item for the annotation db
    int dbIdx;
    for(dbIdx=0; dbIdx < mRootItem->childCount(); dbIdx++)
    {
        TreeItem* item = mRootItem->child(dbIdx);
        if (item->data(DbId).toString() == dbUid)
        {
            parentDB = item;
            break;
        }
    }

    if (parentDB == nullptr)
    {
        // Create DB entry
        QHash<int, QVariant> dbColData4Db;
        dbColData4Db.insert(Id, QVariant());
        dbColData4Db.insert(DbId, QVariant(dbUid));
        dbColData4Db.insert(Order, QVariant(dbIdx));
        dbColData4Db.insert(Selected, QVariant(isDbSelected));
        dbColData4Db.insert(Name, QVariant(fullName));
        dbColData4Db.insert(Version, QVariant(dbVersion));
        dbColData4Db.insert(Description, QVariant(dbDescription));
        dbColData4Db.insert(SearchField,  QVariant(dbName + " " + dbDescription + " " + dbVersion));

        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        parentDB = new TreeItem(dbColData4Db, mRootItem);
        mRootItem->appendChild(parentDB);
        endInsertRows();
    }

    if (isDbSelected)
    {
        // todo
    }

    // create fields entry
    QString uid = data->annotation()->uid();

    QHash<int, QVariant> annotColData;
    annotColData.insert(Id, QVariant(uid));
    annotColData.insert(DbId, QVariant(dbUid));
    annotColData.insert(Order, QVariant(data->annotation()->order()));
    annotColData.insert(Selected, QVariant(data->isDisplayed()));
    annotColData.insert(Name, QVariant(data->annotation()->name()));
    annotColData.insert(Description, QVariant(data->annotation()->description()));
    annotColData.insert(SearchField,  QVariant(dbName + " " + dbDescription + " " + dbVersion + " " + data->annotation()->name() + " " + data->annotation()->description()));

    // retrieve index of the parent item
    beginInsertRows(index(dbIdx, 0, QModelIndex()), parentDB->childCount(), parentDB->childCount());
    TreeItem* annotItem = new TreeItem(annotColData, parentDB);
    parentDB->appendChild(annotItem);
    endInsertRows();

}
