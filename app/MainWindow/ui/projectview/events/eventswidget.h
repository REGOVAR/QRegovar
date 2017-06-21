#ifndef EVENTSWIDGET_H
#define EVENTSWIDGET_H

#include <QWidget>
#include <QTableView>
#include <QPushButton>

#include "model/projectmodel.h"

namespace projectview
{



class EventsWidget : public QFrame
{
    Q_OBJECT
private:
    QTableView* mEventsTable;
    QPushButton* mAddButton;
    QPushButton* mEditButton;
    QPushButton* mRemoveButton;


public:
    explicit EventsWidget(QWidget *parent = 0);

    void setProject(ProjectModel* project);

Q_SIGNALS:


public Q_SLOTS:



};
} // END namespace projectview
#endif // EVENTSWIDGET_H
