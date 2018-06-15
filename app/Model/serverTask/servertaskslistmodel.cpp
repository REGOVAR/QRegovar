#include "servertaskslistmodel.h"
#include "Model/regovar.h"

ServerTasksListModel::ServerTasksListModel(QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(UpdateDate);
}




ServerTask* ServerTasksListModel::getOrCreateTask(QString action, QJsonObject data)
{
    QString id = action + "_" + QString::number(data["id"].toInt());
    if (!mServerTaskMap.contains(id))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        ServerTask* task = new ServerTask(this);
        mServerTaskList.append(task);
        mServerTaskMap[id] = task;
        endInsertRows();
    }

    data.insert("task_action", action);
    mServerTaskMap[id]->loadJson(data);

    emit dataChanged(index(0), index(rowCount()-1));
    emit countChanged();
    return mServerTaskMap[id];
}



// QAbstractListModel methods
int ServerTasksListModel::rowCount(const QModelIndex&)const
{
    return mServerTaskList.count();
}



QVariant ServerTasksListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mServerTaskList.count())
        return QVariant();

    const ServerTask* task= mServerTaskList[index.row()];
    if (role == Label || role == Qt::DisplayRole)
        return task->label();
    else if (role == Id)
        return task->id();
    else if (role == Status)
        return task->status();
    else if (role == Progress)
        return task->progress();
    else if (role == UpdateDate)
        return regovar->formatDate(task->updateDate());
    else if (role == SearchField)
        return task->searchField();
    return QVariant();
}



QHash<int, QByteArray> ServerTasksListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Status] = "status";
    roles[Progress] = "progress";
    roles[Label] = "label";
    roles[UpdateDate] = "updateDate";
    roles[SearchField] = "searchField";
    return roles;
}
