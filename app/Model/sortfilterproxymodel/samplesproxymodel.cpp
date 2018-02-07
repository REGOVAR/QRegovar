#include "samplesproxymodel.h"

SamplesProxyModel::SamplesProxyModel(QObject* parent):  QSortFilterProxyModel(parent)
{
    setSortOrder(0, 1);
}


void SamplesProxyModel::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

void SamplesProxyModel::setSortOrder(int column, int order)
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
