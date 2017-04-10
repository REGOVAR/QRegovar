#ifndef PROJECTVIEWWIDGET_H
#define PROJECTVIEWWIDGET_H

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
    QLabel* titleLabel;
    QLabel* statusLabel;

    QPushButton* toggleBrowserButton;

    ResumeWidget* resumePage;
    QTableWidget* subjectPage;
    QTableWidget* taskPage;
    QTreeView* filePage;


public:
    explicit ProjectWidget(QWidget *parent = 0);
    void setProject();

Q_SIGNALS:

public Q_SLOTS:
    void onSectionChanged(QListWidgetItem*, QListWidgetItem*);

};
} // END namespace projectview
#endif // PROJECTVIEWWIDGET_H
