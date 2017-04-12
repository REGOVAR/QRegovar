#ifndef RESUMEWIDGET_H
#define RESUMEWIDGET_H

#include <QWidget>
#include <QTableView>
#include <QLabel>

#include "model/projectmodel.h"

namespace projectview
{



class ResumeWidget : public QWidget
{
    Q_OBJECT
private:
    QLabel* mCommentLabel;
    QLabel* mSharedUserLabel;
    QTableView* mEventsTable;
    QTableView* mSubjectsTable;
    QTableView* mTasksTable;
    QTableView* mFilesTable;



public:
    explicit ResumeWidget(QWidget *parent = 0);

    void setProject(ProjectModel* project);

Q_SIGNALS:


public Q_SLOTS:



};
} // END namespace projectview
#endif // RESUMEWIDGET_H
