#include "annotationsproxymodel.h"

AnnotationsProxyModel::AnnotationsProxyModel(QObject* parent):  QSortFilterProxyModel(parent)
{
    setSortOrder(0, 1);
    // setRecursiveFiltering(true);
}


void AnnotationsProxyModel::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

void AnnotationsProxyModel::setSortOrder(int column, int order)
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
