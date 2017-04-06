#ifndef PROJECTVIEWWIDGET_H
#define PROJECTVIEWWIDGET_H

#include <QWidget>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QToolBar>
#include <QStackedWidget>
#include <QLabel>

class ProjectViewWidget : public QWidget
{
    Q_OBJECT

private:
    QToolBar* mSectionBar;
    QToolBar* mToolBar;
    QStackedWidget* mStackWidget;
    QWidget* mResumeTab;
    QLabel* projectTitle;
    QLabel* projectStatus;

public:
    explicit ProjectViewWidget(QWidget *parent = 0);

Q_SIGNALS:

public Q_SLOTS:
    void showSettings();

};

#endif // PROJECTVIEWWIDGET_H
