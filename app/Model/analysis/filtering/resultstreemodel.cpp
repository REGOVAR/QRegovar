#include <QDebug>
#include <QtNetwork>
#include "resultstreemodel.h"
#include "resultstreeitem.h"
#include "Model/request.h"
#include "Model/regovar.h"



ResultsTreeModel::ResultsTreeModel(FilteringAnalysis* parent) : TreeModel(parent)
{
    mFilteringAnalysis = parent;
    QHash<int, QVariant> rootData;
    mRootItem = new TreeItem(rootData);

    mAnalysisId = -1;
}


void ResultsTreeModel::initAnalysisData(int analysisId)
{
    mAnalysisId = analysisId;
    clear();
}

bool ResultsTreeModel::fromJson(QJsonObject json)
{
    qDebug() << "Init results tree model of filtering analysis" << mAnalysisId << ":";

    // With QML TreeView, the rootItem must know all column's roles to allow correct display for
    // other rows. So that's why we create columns for all existings roles.
    QHash<int, QVariant> rootData;
    QHash<int, QByteArray> roles = roleNames();
    foreach (int roleId, roles.keys())
    {
        rootData.insert(roleId, QString(roles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

    return true;
}





void ResultsTreeModel::refresh()
{
    setIsLoading(true);

    QJsonDocument filter = QJsonDocument::fromJson(mFilteringAnalysis->filter().toUtf8());
    QJsonObject body;
    body.insert("filter", filter.array());
    body.insert("fields", QJsonArray::fromStringList(mFilteringAnalysis->fields()));

    Request* request = Request::post(QString("/analysis/%1/filtering").arg(mAnalysisId), QJsonDocument(body).toJson());
    connect(request, &Request::responseReceived, [this, request](bool success, const QJsonObject& json)
    {
        if (success)
        {
            beginResetModel();
            clear();
            setupModelData(json["data"].toArray(), mRootItem);
            endResetModel();
            qDebug() << Q_FUNC_INFO << "Results TreeViewModel refreshed";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build results tree model (due to request error)";
        }
        setIsLoading(false);
        request->deleteLater();
    });
}






QHash<int, QByteArray> ResultsTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int roleId = Qt::UserRole + 1;
    roles[roleId] = "id";
    ++roleId;
    // Build role from annotations all annotations available list
    foreach (QString uid, mFilteringAnalysis->annotations()->annotations()->keys())
    {
        roles[roleId] = uid.toUtf8();

        // DEBUG
//        AnnotationModel* annot = regovar->currentAnnotations()->getAnnotation(uid);
//        qDebug() << "role " << roleId << "=" << roles[roleId] << annot->name();

        ++roleId;
    }
    qDebug() << "Result Tree's roles defined : " << roles.count() << "roles";
    return roles;
}


//! Create treeview item with provided data, according to the type of the annotation
QVariant ResultsTreeModel::newResultsTreeViewItem(Annotation* annot, QString uid, const QJsonValue &value)
{

    if (annot != nullptr && annot->type() == "sample_array")
    {
        QJsonObject meta = annot->meta();
        ResultsTreeItem4SampleArray *t = new ResultsTreeItem4SampleArray(mFilteringAnalysis);
        t->setUid(uid);
        t->setType(meta["type"].toString());

        QJsonObject data = value.toObject();



        foreach (QString sampleId, data.keys())
        {
            int a = sampleId.toInt();
            QVariant b = data[sampleId].toVariant();
            t->samplesValues()->insert(a, b);
        }
        t->refreshDisplayedValues();
        QVariant v;
        v.setValue(t);
        return v;
    }
    else
    {
        ResultsTreeItem *t = new ResultsTreeItem(mFilteringAnalysis);
        t->setValue(value.toVariant());
        t->setUid(uid);
        QVariant v;
        v.setValue(t);
        return v;
    }
}


void ResultsTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    QHash<int, QByteArray> roles = roleNames();
    foreach(const QJsonValue json, data)
    {
        QJsonObject r = json.toObject();
        QString id = r["id"].toString();
        QHash<int, QVariant> columnData;

        columnData.insert(roles.key("id"), newResultsTreeViewItem(nullptr, id, QJsonValue(id)));

        foreach (QString uid, mFilteringAnalysis->fields())
        {
            Annotation* annot = mFilteringAnalysis->annotations()->getAnnotation(uid);
            columnData.insert(roles.key(uid.toUtf8()), newResultsTreeViewItem(annot, id, r[uid]));
        }
        // qDebug() << "Load variant : " << id;

        // Create treeview item with column's data and parent item
        TreeItem* item = new TreeItem(columnData, parent);
        parent->appendChild(item);
    }
    qDebug() << "Result Model Ready :" << parent->childCount() << "items loaded";
}
