#include <QDebug>
#include <QtNetwork>
#include "remotesampletreemodel.h"
#include "remotesampletreeitem.h"
#include "Model/request.h"
#include "Model/regovar.h"



RemoteSampleTreeModel::RemoteSampleTreeModel(FilteringAnalysis* parent) : TreeModel(parent)
{
    mFilteringAnalysis = parent;

    // Init roles
    mRoles[nameRole] = "name";
    mRoles[commentRole] = "comment";
    mRoles[statusRole] = "status";
    mRoles[filenameRole] = "filename";
    mRoles[importDateRole] = "importDate";
    mRoles[subjectIdRole] = "subjectId";
    mRoles[firstnameRole] = "firstname";
    mRoles[lastnameRole] = "lastname";
    mRoles[sexRole] = "sex";
    mRoles[birthdayRole] = "birthday";
    mRoles[deathdayRole] = "deathday";

    // Init root item with all roles
    QHash<int, QVariant> rootData;
    foreach (int roleId, mRoles.keys())
    {
        rootData.insert(roleId, QString(mRoles[roleId]));
    }
    mRootItem = new TreeItem(rootData);

    reset();
}


QHash<int, QByteArray> RemoteSampleTreeModel::roleNames() const
{
    return mRoles;
}









//! Reset the Treemodel with data for the current filter set in the FilteringAnalysis
void RemoteSampleTreeModel::reset()
{
    setIsLoading(true);

    Request* request = Request::get(QString("/sample/browserTree/%1").arg(mFilteringAnalysis->refId()));
    connect(request, &Request::responseReceived, [this, request](bool success, QJsonObject json)
    {
        if (success)
        {
            beginResetModel();
            clear();
            setupModelData(json["data"].toArray(), mRootItem);
            qDebug() << Q_FUNC_INFO << "Remote samples TreeViewModel reset.";
        }
        else
        {
            qCritical() << Q_FUNC_INFO << "Unable to build remote samples tree model (due to request error)";
        }
        setIsLoading(false);
        request->deleteLater();
    });
}










//! Create treeview item with provided data, according to the type of the annotation
QVariant RemoteSampleTreeModel::newRemoteSampleTreeViewItem(int sampleId, int subjectId, int fileId, const QJsonValue &value)
{

    RemoteSampleTreeItem *t = new RemoteSampleTreeItem(sampleId, subjectId, fileId, value.toVariant(), mFilteringAnalysis);
    QVariant v;
    v.setValue(t);
    return value.toVariant(); //v;
}


void RemoteSampleTreeModel::setupModelData(QJsonArray data, TreeItem *parent)
{
    foreach(const QJsonValue jsonSubject, data)
    {
        QJsonObject subject = jsonSubject.toObject();

        QHash<int, QVariant> subjectColData;
        subjectColData.insert(subjectIdRole, subject["id"].toVariant());
        subjectColData.insert(nameRole,      subject["identifiant"].toVariant());
        subjectColData.insert(commentRole,   subject["comment"].toString());
        subjectColData.insert(firstnameRole, subject["firstname"].toString());
        subjectColData.insert(lastnameRole,  subject["lastname"].toString());
        subjectColData.insert(sexRole,       subject["sex"].toString());
        subjectColData.insert(birthdayRole,  subject["birthday"].toString());
        subjectColData.insert(deathdayRole,  subject["deathday"].toString());

        // Create treeview item with column's data and parent item
        TreeItem* subjectItem = new TreeItem(subjectColData, parent);
        parent->appendChild(subjectItem);

        foreach(const QJsonValue jsonSample, subject["samples"].toArray())
        {
            QJsonObject sample = jsonSample.toObject();
            QHash<int, QVariant> sampleColData;
            sampleColData.insert(sampleIdRole,   sample["id"].toInt());
            sampleColData.insert(nameRole,       sample["name"].toString());
            sampleColData.insert(commentRole,    sample["comment"].toString());
            sampleColData.insert(filenameRole,   sample["filename"].toString());
            sampleColData.insert(importDateRole, sample["import_date"].toString());

            QString status = sample["status"].toString();
            if (status == "importing")
            {
                status += QString(": %1 %").arg(sample["loading_progress"].toString());
            }
            sampleColData.insert(statusRole, status);
            TreeItem* sampleItem = new TreeItem(sampleColData, subjectItem);
            subjectItem->appendChild(sampleItem);
        }
    }
    qDebug() << "Remote sample tree model ready :";
}
