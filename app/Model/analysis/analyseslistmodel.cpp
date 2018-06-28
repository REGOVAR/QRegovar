#include "analyseslistmodel.h"
#include "analysis.h"
#include "Model/regovar.h"

AnalysesListModel::AnalysesListModel(QObject *parent) : QAbstractListModel(parent)
{
    mProxy = new GenericProxyModel(this);
    mProxy->setSourceModel(this);
    mProxy->setFilterRole(SearchField);
    mProxy->setSortRole(Name);
}


void AnalysesListModel::propagateDataChanged()
{
    // When a analysis in the model emit a datachange, the list need to
    // notify its view to refresh too
    Analysis* analysis = (Analysis*) sender();
    if (analysis!= nullptr && mAnalyses.contains(analysis))
    {
        emit dataChanged(index(mAnalyses.indexOf(analysis)), index(mAnalyses.indexOf(analysis)));
    }
}


void AnalysesListModel::clear()
{
    beginResetModel();
    for (Analysis* a: mAnalyses)
        disconnect(a, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
    mAnalyses.clear();
    endResetModel();
    emit countChanged();
}


bool AnalysesListModel::loadJson(const QJsonArray& json)
{
    beginResetModel();
    for (Analysis* a: mAnalyses)
        disconnect(a, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
    mAnalyses.clear();
    for(const QJsonValue& val: json)
    {
        QJsonObject data = val.toObject();
        Analysis* a = nullptr;
        if (data["type"] == "analysis")
        {
           a = (Analysis*) regovar->analysesManager()->getOrCreateFilteringAnalysis(data["id"].toInt());
        }
        else if (data["type"] == "pipeline")
        {
            a = (Analysis*) regovar->analysesManager()->getOrCreatePipelineAnalysis(data["id"].toInt());
        }
        if (a != nullptr && !mAnalyses.contains(a))
        {
            a->loadJson(data);
            mAnalyses.append(a);
            connect(a, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
        }
    }
    endResetModel();
    emit countChanged();
    return true;
}


bool AnalysesListModel::append(Analysis* analysis)
{
    if (analysis!= nullptr && !mAnalyses.contains(analysis))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mAnalyses.append(analysis);
        connect(analysis, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
        endInsertRows();
        emit countChanged();
        return true;
    }
    return false;
}

bool AnalysesListModel::remove(Analysis* analysis)
{
    if (mAnalyses.contains(analysis))
    {
        int pos = mAnalyses.indexOf(analysis);
        beginRemoveRows(QModelIndex(), pos, pos);
        mAnalyses.removeAll(analysis);
        disconnect(analysis, SIGNAL(dataChanged()), this, SLOT(propagateDataChanged()));
        endRemoveRows();
        emit countChanged();
        return true;
    }
    return false;
}


Analysis* AnalysesListModel::getAt(int idx)
{
    if (idx >=0 && idx<mAnalyses.count())
    {
        return mAnalyses[idx];
    }
    return nullptr;
}


int AnalysesListModel::rowCount(const QModelIndex&) const
{
    return mAnalyses.count();
}


QVariant AnalysesListModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= mAnalyses.count())
        return QVariant();

    Analysis* analysis = mAnalyses[index.row()];
    if (role == Name || role == Qt::DisplayRole)
        return analysis->name();
    else if (role == Id)
        return analysis->id();
    else if (role == FullPathName)
    {
        QJsonArray path;
        if (analysis->project() != nullptr)
            path.append(analysis->project()->name());
        path.append(analysis->name());
        return path;
    }
    else if (role == Type)
        return analysis->type();
    else if (role == Comment)
        return analysis->comment();
    else if (role == Project && analysis->project() != nullptr)
        return analysis->project()->name();
    else if (role == Status)
        return analysis->status();
    else if (role == UpdateDate)
        return analysis->updateDate().toString("yyyy-MM-dd HH:mm");
    else if (role == SearchField)
        return analysis->searchField();
    return QVariant();
}


QHash<int, QByteArray> AnalysesListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id] = "id";
    roles[Name] = "name";
    roles[FullPathName] = "fullpathName";
    roles[Comment] = "comment";
    roles[Type] = "type";
    roles[Project] = "project";
    roles[Status] = "status";
    roles[UpdateDate] = "updateDate";
    roles[SearchField] = "searchField";
    return roles;
}
