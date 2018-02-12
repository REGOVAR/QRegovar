#include "genericproxymodel.h"

GenericProxyModel::GenericProxyModel(QObject* parent):  QSortFilterProxyModel(parent)
{
    setSortOrder(0, 1);
}


void GenericProxyModel::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}


void GenericProxyModel::setSortOrder(int column, int order)
{
    if(order == 0)
    {
        this->sort(column, Qt::DescendingOrder);
    }
    else
    {
        this->sort(column, Qt::AscendingOrder);
    }
}


QModelIndex GenericProxyModel::getModelIndex(int row)
{
    QModelIndex sourceIndex = mapToSource(this->index(row, 0));
    return sourceIndex;
}
