#include "pipelineslistmodel.h"
#include "Model/regovar.h"

PipelinesListModel::PipelinesListModel(QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}




bool PipelinesListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mPipelinesList.clear();
    for (const QJsonValue& pipeJson: json)
    {
        QJsonObject pipeData = pipeJson.toObject();
        Pipeline* pipe = regovar->pipelinesManager()->getOrCreatePipe(pipeData["id"].toInt());
        pipe->loadJson(pipeData);
        if (!mPipelinesList.contains(pipe))
        {
            mPipelinesList.append(pipe);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}


bool PipelinesListModel::add(Pipeline* pipe)
{
    if (!mPipelinesList.contains(pipe))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPipelinesList.append(pipe);
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}




bool PipelinesListModel::refresh()
{
    qDebug() << "TODO: PipelinesListModel::refresh()";
    return false;
}





int PipelinesListModel::rowCount(const QModelIndex&) const
{
    return mPipelinesList.count();
}



QVariant PipelinesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mPipelinesList.count())
        return QVariant();

    const Pipeline* pipe= mPipelinesList[index.row()];
    if (role == Name || role == Qt::DisplayRole)
        return pipe->name();
    else if (role == Id)
        return pipe->id();
    else if (role == Type)
        return pipe->type();
    else if (role == Status)
        return pipe->status();
    else if (role == Starred)
        return pipe->starred();
    else if (role == Description)
        return pipe->description();
    else if (role == SearchField)
        return pipe->searchField();
    return QVariant();
}



QHash<int, QByteArray> PipelinesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[Description] = "description";
    roles[Type] = "type";
    roles[Status] = "status";
    roles[Authors] = "authors";
    roles[SearchField] = "searchField";
    return roles;
}
