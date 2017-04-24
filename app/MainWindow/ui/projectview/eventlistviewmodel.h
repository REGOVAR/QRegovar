#ifndef EVENTLISTVIEWMODEL_H
#define EVENTLISTVIEWMODEL_H


#include <QAbstractListModel>
#include "model/eventmodel.h"



class EventListViewModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum
    {
        DateColumn = 0,
        UserColumn,
        MessageColumn
    };


    EventListViewModel(QObject* parent=nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const Q_DECL_OVERRIDE;



private:
    QList<EventModel*> mEvents;
};

#endif // EVENTLISTVIEWMODEL_H
