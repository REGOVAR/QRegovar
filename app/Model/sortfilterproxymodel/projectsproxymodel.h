#ifndef PROJECTSPROXYMODEL_H
#define PROJECTSPROXYMODEL_H


#include <QtCore>

class ProjectsProxyModel: public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit ProjectsProxyModel(QObject* parent=nullptr);

    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setSortOrder(int column, int order);

public Q_SLOTS:
    int getModelIndex(int);
};

#endif // PROJECTSPROXYMODEL_H
