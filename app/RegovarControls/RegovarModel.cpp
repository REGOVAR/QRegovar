#include "RegovarModel.h"

RegovarModel::RegovarModel(QObject *parent)
    :QAbstractListModel(parent)
{
    mDatas.append("begin");
    mDatas.append("Qt");
    mDatas.append("is");
    mDatas.append("the best");



}

int RegovarModel::rowCount(const QModelIndex &parent) const
{
    return mDatas.count();
}

QVariant RegovarModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == Qt::DisplayRole)
    {
        return mDatas[index.row()];

    }

    if (role == TitleRole)
    {
        return mDatas[index.row()];

    }

    if (role == InvertRole)
    {
        return mDatas[index.row()].toUpper();

    }

    return QVariant();

}

QHash<int, QByteArray> RegovarModel::roleNames() const
{
    // Creation des roles accessible depuis QML
    QHash<int, QByteArray> customRoles = QAbstractItemModel::roleNames();

    customRoles[TitleRole] = "title";
    customRoles[InvertRole] = "invert";

    return customRoles;


}

void RegovarModel::add()
{
   beginResetModel();
   mDatas.append("action");
   endResetModel();
}
