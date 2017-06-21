#include "eventswidget.h"

#include <QIcon>
#include <QSplitter>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QPushButton>
#include <QHeaderView>

#include "eventlistviewmodel.h"


namespace projectview
{



EventsWidget::EventsWidget(QWidget *parent) : QFrame(parent)
{
    QFont titleFont( "Arial", 14, QFont::Bold);
    mEventsTable = new QTableView(this);

    mEventsTable->horizontalHeader()->setStretchLastSection(true);
    mEventsTable->setSelectionBehavior(QAbstractItemView::SelectRows);

    mAddButton = new QPushButton(tr("Add event"));
    mEditButton = new QPushButton(tr("Edit event"));
    mRemoveButton = new QPushButton(tr("Remove event"));

    QWidget* stretcher = new QWidget(this);
    stretcher->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Expanding);


    QVBoxLayout* controlsLayout = new QVBoxLayout(this);
    controlsLayout->addWidget(mAddButton);
    controlsLayout->addWidget(mEditButton);
    controlsLayout->addWidget(mRemoveButton);
    controlsLayout->addWidget(stretcher);

    QHBoxLayout* mainLayout = new QHBoxLayout(this);
    mainLayout->addWidget(mEventsTable);
    mainLayout->addLayout(controlsLayout);

    setLayout(mainLayout);

    setFrameStyle(QFrame::StyledPanel | QFrame::Plain);
    setAutoFillBackground(true);
    setBackgroundRole(QPalette::Base);
}


void EventsWidget::setProject(ProjectModel* project)
{
    if (project != nullptr)
    {
        mEventsTable->setModel(new EventListViewModel);
    }
}

} // END namespace projectview
