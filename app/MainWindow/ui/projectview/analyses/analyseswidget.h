#ifndef ANALYSESWIDGET_H
#define ANALYSESWIDGET_H

#include <QWidget>
#include <QTableView>
#include <QPushButton>


namespace projectview
{



class AnalysesWidget : public QFrame
{
    Q_OBJECT
private:
    QTableView* mAnalysesTable;

public:
    explicit AnalysesWidget(QWidget *parent = 0);


Q_SIGNALS:


public Q_SLOTS:



};
} // END namespace projectview
#endif // ANALYSESWIDGET_H
