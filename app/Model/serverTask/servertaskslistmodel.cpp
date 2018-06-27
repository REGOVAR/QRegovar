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

        qDebug() << "NEW SERVER TASK:" << id << ":" << data;
        endInsertRows();
    }

    data.insert("task_action", action);
    mServerTaskMap[id]->loadJson(data);

    emit dataChanged(index(0), index(rowCount()-1));
    emit countChanged();
    return mServerTaskMap[id];
}


float ServerTasksListModel::updateProgress()
{
    float total = 0;
    if (mServerTaskList.count() > 0)
    {
        for(ServerTask* task: mServerTaskList)
        {
            total += task->progress();
        }
        total /= mServerTaskList.count();
    }
    else
    {
        total = -1;
    }
    mProgress = total;
    emit progressChanged();
    return total;
}


void ServerTasksListModel::pause(QString id)
{
    if (mServerTaskMap.contains(id))
    {
        ServerTask* task = mServerTaskMap[id];
        task->pause();
    }
}
void ServerTasksListModel::cancel(QString id)
{
    if (mServerTaskMap.contains(id))
    {
        ServerTask* task = mServerTaskMap[id];
        task->cancel();
    }
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
    if (role == Qt::DisplayRole)
        return task->label();
    else if (role == Id)
        return task->id();
    else if (role == Label)
    {
        QJsonObject data;
        data.insert("id", task->id());
        data.insert("label", task->label());
        return data;
    }
    else if (role == Status)
    {
        QJsonObject data;
        data.insert("id", task->id());
        data.insert("enableControls", task->enableControls() );
        data.insert("status", task->status()); // done, running, pause
        return data;
    }
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
