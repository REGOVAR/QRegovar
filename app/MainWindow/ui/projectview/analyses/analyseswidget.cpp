#include "analyseswidget.h"

#include <QLabel>
#include <QHBoxLayout>



namespace projectview
{



AnalysesWidget::AnalysesWidget(QWidget *parent) : QFrame(parent)
{

    mAnalysesTable = new QTableView(this);

    mAnalysesTable->setSelectionBehavior(QAbstractItemView::SelectRows);

    QLabel* label = new QLabel(tr("hello"));

    QHBoxLayout* mainLayout = new QHBoxLayout(this);
    mainLayout->addWidget(label);

    setLayout(mainLayout);

    setFrameStyle(QFrame::StyledPanel | QFrame::Plain);
    setAutoFillBackground(true);
    setBackgroundRole(QPalette::Base);
}



} // END namespace projectview
