#ifndef ANALYSESWIDGET_H
#define ANALYSESWIDGET_H


#include <QFrame>
#include <QTableView>
#include <QPushButton>


namespace projectview
{



class AnalysisWidget  : public QFrame
{
     Q_OBJECT

private:
    QTableView* mEventsTable;
    QPushButton* mAddButton;
    QPushButton* mEditButton;
    QPushButton* mRemoveButton;


public:
    explicit AnalysisWidget(QWidget *parent = 0);


Q_SIGNALS:


public Q_SLOTS:



};
} // END namespace projectview
#endif // ANALYSESWIDGET_H