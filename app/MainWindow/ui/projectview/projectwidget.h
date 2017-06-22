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
#include "model/projectmodel.h"

#include "ui/projectview/resume/resumewidget.h"
#include "ui/projectview/events/eventswidget.h"
#include "ui/projectview/settings/settingswidget.h"
#include "ui/projectview/analysis/analysiswidget.h"

namespace projectview
{


class ProjectWidget : public QWidget
{
    Q_OBJECT

private:
    // Views
    QStackedWidget* mStackWidget;
    QListWidget* mSectionBar;
    ResumeWidget* mResumeWidget;
    EventsWidget* mEventsWidget;
    QWidget* mSubjectsWidget;
    AnalysisWidget* mAnalysesWidget;
    QWidget* mFilesWidget;
    SettingsWidget* mSettingsWidget;

    // Model
    ProjectModel* mProject;


public:
    explicit ProjectWidget(QWidget *parent = 0);
    const ProjectModel* project() const;
    void setProject(ProjectModel* project);

    void initView();


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
