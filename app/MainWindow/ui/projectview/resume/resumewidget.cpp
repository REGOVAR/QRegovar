#include "resumewidget.h"

#include <QIcon>
#include <QSplitter>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHeaderView>

#include "../events/eventlistviewmodel.h"


namespace projectview
{



ResumeWidget::ResumeWidget(QWidget *parent) : QWidget(parent)
{
    QFont titleFont( "Arial", 14, QFont::Bold);
    mCommentLabel = new QLabel(this);
    mSharedUserLabel = new QLabel(this);
    mEventsTable = new QTableView(this);
    mSubjectsTable = new QTableView(this);
    mTasksTable = new QTableView(this);
    mFilesTable = new QTableView(this);

    mEventsTable->horizontalHeader()->setStretchLastSection(true);
    mEventsTable->setSelectionBehavior(QAbstractItemView::SelectRows);

    QVBoxLayout* subjectsLayout = new QVBoxLayout(this);
    QLabel* subjectsLabel = new QLabel(tr("Subjects :"));
    subjectsLabel->setFont(titleFont);
    subjectsLayout->addWidget(subjectsLabel);
    subjectsLayout->addWidget(mSubjectsTable);

    QVBoxLayout* tasksLayout = new QVBoxLayout(this);
    QLabel* tasksLabel = new QLabel(tr("Analyses :"));
    tasksLabel->setFont(titleFont);
    tasksLayout->addWidget(tasksLabel);
    tasksLayout->addWidget(mTasksTable);

    QVBoxLayout* filesLayout = new QVBoxLayout(this);
    QLabel* filesLabel = new QLabel(tr("Reports :"));
    filesLabel->setFont(titleFont);
    filesLayout->addWidget(filesLabel);
    filesLayout->addWidget(mFilesTable);

    QSplitter* splitter = new QSplitter(this);
    QWidget* panel1 = new QWidget(this);
    panel1->setLayout(subjectsLayout);
    QWidget* panel2 = new QWidget(this);
    panel2->setLayout(tasksLayout);
    QWidget* panel3 = new QWidget(this);
    panel3->setLayout(filesLayout);
    splitter->addWidget(panel1);
    splitter->addWidget(panel2);
    splitter->addWidget(panel3);

    QLabel* eventsLabel = new QLabel(tr("Events :"));
    eventsLabel->setFont(titleFont);
    eventsLabel->setStyleSheet("QLabel { color : rgba(0,0,0, 0.5); }");

    QGridLayout* mainLayout = new QGridLayout(this);
    mainLayout->addWidget(new QLabel(tr("Comment :")),0,0);
    mainLayout->addWidget(mCommentLabel,0,1);
    mainLayout->addWidget(new QLabel(tr("Shared :")),1,0);
    mainLayout->addWidget(mSharedUserLabel,1,1);
    mainLayout->addWidget(eventsLabel,2,0,1,2);
    mainLayout->addWidget(mEventsTable,3,0,1,2);
    mainLayout->addWidget(splitter,4,0,1,2);

    setLayout(mainLayout);
}


void ResumeWidget::setProject(ProjectModel* project)
{
    if (project != nullptr)
    {
        mEventsTable->setModel(new EventListViewModel);
    }
}

} // END namespace projectview
