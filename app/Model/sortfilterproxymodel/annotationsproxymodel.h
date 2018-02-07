#ifndef ANNOTATIONSPROXYMODEL_H
#define ANNOTATIONSPROXYMODEL_H

#include <QtCore>
#include <QtQml>

class AnnotationsProxyModel: public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit AnnotationsProxyModel(QObject* parent=nullptr);

    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setSortOrder(int column, int order);
};

#endif // ANNOTATIONSPROXYMODEL_H
