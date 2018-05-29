#ifndef GENERICPROXYMODEL_H
#define GENERICPROXYMODEL_H

#include <QtCore>

class GenericProxyModel: public QSortFilterProxyModel
{
    Q_OBJECT

public:
    // Constructor
    GenericProxyModel(QObject* parent=nullptr);

    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setSortOrder(int column, int order);

public Q_SLOTS:
    QModelIndex getModelIndex(int);
};

#endif // GENERICPROXYMODEL_H
