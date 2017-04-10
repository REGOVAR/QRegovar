#include "resumewidget.h"

#include <QIcon>
#include <QSplitter>
#include <QVBoxLayout>
#include <QGridLayout>


namespace projectview
{



ResumeWidget::ResumeWidget(QWidget *parent) : QWidget(parent)
{
    QFont titleFont( "Arial", 14, QFont::Bold);
    commentLabel = new QLabel(this);
    sharedUserLabel = new QLabel(this);
    eventsTable = new QTableWidget(this);
    subjectsTable = new QTableWidget(this);
    tasksTable = new QTableWidget(this);
    filesTable = new QTableWidget(this);

    QVBoxLayout* subjectsLayout = new QVBoxLayout(this);
    QLabel* subjectsLabel = new QLabel(tr("Subjects :"));
    subjectsLabel->setFont(titleFont);
    subjectsLayout->addWidget(subjectsLabel);
    subjectsLayout->addWidget(subjectsTable);

    QVBoxLayout* tasksLayout = new QVBoxLayout(this);
    QLabel* tasksLabel = new QLabel(tr("Tasks :"));
    tasksLabel->setFont(titleFont);
    tasksLayout->addWidget(tasksLabel);
    tasksLayout->addWidget(tasksTable);

    QVBoxLayout* filesLayout = new QVBoxLayout(this);
    QLabel* filesLabel = new QLabel(tr("Files :"));
    filesLabel->setFont(titleFont);
    filesLayout->addWidget(filesLabel);
    filesLayout->addWidget(filesTable);

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

    QGridLayout* mainLayout = new QGridLayout(this);
    mainLayout->addWidget(new QLabel(tr("Comment :")),0,0);
    mainLayout->addWidget(commentLabel,0,1);
    mainLayout->addWidget(new QLabel(tr("Shared :")),1,0);
    mainLayout->addWidget(sharedUserLabel,1,1);
    mainLayout->addWidget(eventsLabel,2,0,1,2);
    mainLayout->addWidget(eventsTable,3,0,1,2);
    mainLayout->addWidget(splitter,4,0,1,2);

    setLayout(mainLayout);
}


} // END namespace projectview
