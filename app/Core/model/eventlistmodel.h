#ifndef EVENTLISTMODEL_H
#define EVENTLISTMODEL_H


#include <QAbstractListModel>
#include "eventmodel.h"



class EventListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum
    {
        DateColumn = 0,
        UserColumn,
        MessageColumn
    };


    EventListModel(QObject* parent=nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const Q_DECL_OVERRIDE;


private:
    QList<EventModel*> mEvents;
};

#endif // EVENTLISTMODEL_H
