#ifndef PROJECTSBROWSERWIDGET_H
#define PROJECTSBROWSERWIDGET_H

#include <QWidget>
#include <QToolBar>
#include <QLineEdit>
#include <QTreeWidget>

namespace projectview
{



class ProjectsBrowserWidget : public QWidget
{
    Q_OBJECT

private:
    QLineEdit* mFilter;
    QToolBar* mToolBar;
    QTreeWidget* mBrowser;


public:
    explicit ProjectsBrowserWidget(QWidget *parent = 0);

Q_SIGNALS:

public Q_SLOTS:
    void toggleFilesDisplay();
    void showFavorites();
};
} // END namespace projectview
#endif // PROJECTSBROWSERWIDGET_H
