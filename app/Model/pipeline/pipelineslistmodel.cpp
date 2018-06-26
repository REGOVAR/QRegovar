#include "pipelineslistmodel.h"
#include "Model/regovar.h"

PipelinesListModel::PipelinesListModel(QObject* parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}


void PipelinesListModel::propagateDataChanged()
{
    // When a pipeline in the model emit a datachange, the list need to
    // notify its view to refresh too
    Pipeline* pipe = (Pipeline*) sender();
    if (pipe!= nullptr && mPipelines.contains(pipe))
    {
        emit dataChanged(index(mPipelines.indexOf(pipe)), index(mPipelines.indexOf(pipe)));
    }
}




bool PipelinesListModel::loadJson(QJsonArray json)
{
    beginResetModel();
    mPipelines.clear();
    for (const QJsonValue& pipeJson: json)
    {
        QJsonObject pipeData = pipeJson.toObject();
        Pipeline* pipe = regovar->pipelinesManager()->getOrCreatePipe(pipeData["id"].toInt());
        pipe->loadJson(pipeData);
        if (!mPipelines.contains(pipe))
        {
            mPipelines.append(pipe);
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}


bool PipelinesListModel::append(Pipeline* pipe)
{
    if (!mPipelines.contains(pipe))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mPipelines.append(pipe);
        endInsertRows();
        connect(pipe, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
        emit countChanged();
        return true;
    }
    return false;
}



bool PipelinesListModel::remove(Pipeline* pipe)
{
    if (mPipelines.contains(pipe))
    {
        int pos = mPipelines.indexOf(pipe);
        beginRemoveRows(QModelIndex(), pos, pos);
        mPipelines.removeAt(pos);
        endRemoveRows();
        disconnect(pipe, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
        emit countChanged();
        return true;
    }
    return false;
}


Pipeline* PipelinesListModel::getAt(int position)
{
    if (position >= 0 && position < mPipelines.count())
    {
        return mPipelines[position];
    }
    return nullptr;
}


bool PipelinesListModel::refresh()
{
    qDebug() << "TODO: PipelinesListModel::refresh()";
    return false;
}





int PipelinesListModel::rowCount(const QModelIndex&) const
{
    return mPipelines.count();
}



QVariant PipelinesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mPipelines.count())
        return QVariant();

    const Pipeline* pipe= mPipelines[index.row()];
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
    else if (role == Version)
        return pipe->version();
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
    roles[Version] = "version";
    roles[Type] = "type";
    roles[Status] = "status";
    roles[Authors] = "authors";
    roles[SearchField] = "searchField";
    return roles;
}
