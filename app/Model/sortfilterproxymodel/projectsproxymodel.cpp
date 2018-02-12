#include "projectsproxymodel.h"


ProjectsProxyModel::ProjectsProxyModel(QObject* parent):  QSortFilterProxyModel(parent)
{
    setSortOrder(0, 1);
}


void ProjectsProxyModel::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}


void ProjectsProxyModel::setSortOrder(int column, int order)
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


int ProjectsProxyModel::getModelIndex(int row)
{
    QModelIndex sourceIndex = mapToSource(this->index(row, 0));
    return sourceIndex.row();
}

