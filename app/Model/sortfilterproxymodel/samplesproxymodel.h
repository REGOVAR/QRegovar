#ifndef SAMPLESPROXYMODEL_H
#define SAMPLESPROXYMODEL_H


#include <QtCore>
#include <QtQml>


class SamplesProxyModel: public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit SamplesProxyModel(QObject* parent=nullptr);

    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setSortOrder(int column, int order);

};

#endif // SAMPLESPROXYMODEL_H
