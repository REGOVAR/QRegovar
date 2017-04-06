#ifndef PROJECTVIEWWIDGET_H
#define PROJECTVIEWWIDGET_H

#include <QWidget>

#include <QToolBar>
#include <QListWidget>
#include <QStackedWidget>
#include <QPushButton>
#include <QLabel>

class ProjectViewWidget : public QWidget
{
    Q_OBJECT

private:
    QListWidget* mSectionBar;
    QToolBar* mToolBar;
    QStackedWidget* mStackWidget;
    QWidget* mResumeTab;
    QLabel* projectTitle;
    QLabel* projectStatus;
    QPushButton* toggleBrowserButton;

public:
    explicit ProjectViewWidget(QWidget *parent = 0);

Q_SIGNALS:

public Q_SLOTS:
    void showSettings();

};

#endif // PROJECTVIEWWIDGET_H
