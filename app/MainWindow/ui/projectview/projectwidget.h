#ifndef PROJECTWIDGET_H
#define PROJECTWIDGET_H

#include <QWidget>
#include <QToolBar>
#include <QListWidget>
#include <QStackedWidget>
#include <QPushButton>
#include <QLabel>
#include <QTableWidget>
#include <QTreeView>
#include <QListWidgetItem>
#include "resumewidget.h"
#include "projectsbrowserwidget.h"
#include "model/projectmodel.h"


namespace projectview
{


class ProjectWidget : public QWidget
{
    Q_OBJECT

private:
    QListWidget* mSectionBar;
    QToolBar* mToolBar;
    QStackedWidget* mStackWidget;
    QWidget* mResumeTab;
    QLabel* mTitleLabel;
    QLabel* mStatusLabel;

    QPushButton* mToggleBrowserButton;

    ResumeWidget* mResumePage;
    QTableWidget* mSubjectPage;
    QTableWidget* mTaskPage;
    QTreeView* mFilePage;
    ProjectsBrowserWidget* mBrowser;

    ProjectModel* mProject;


public:
    explicit ProjectWidget(QWidget *parent = 0);
    void setProject();

    const ProjectModel* project() const;
    void setProject(ProjectModel* project);

    void initView();





Q_SIGNALS:

public Q_SLOTS:
    void displaySection(QListWidgetItem*, QListWidgetItem*);
    void showProjectSettings();
    void showAddSubjectsData();
    void showNewTask();
    void showAddEvent();
    void showAddAttachment();
    void toggleBrowser();

};
} // END namespace projectview
#endif // PROJECTWIDGET_H
