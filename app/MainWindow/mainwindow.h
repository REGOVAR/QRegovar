#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QVBoxLayout>
#include <QTabWidget>
#include <QMessageBox>
#include <QtWidgets>
#include <QQuickView>
#include <QFileSystemModel>
#include <QQmlContext>

#include "regovar.h"
#include "ui/loginwidget.h"
#include "ui/jobview/jobwidget.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget* parent = 0);
    ~MainWindow();

    // Overriden methods
    void closeEvent(QCloseEvent*);


    // Tools
    void restoreSettings();
    void writeSettings();


public Q_SLOTS:
    void about();
    void settings();
    void admin();
    void newProject();

    void logoutUser();
    void loginUser();
    void displayLoginFailedError();
    void updateMainWindow();

protected:
    void buildMenu();
    QWidget* buildHomeWidget();
    void createDockWindows();

    QTreeView *customerList;
    QListWidget *paragraphsList;


    // Widget containers
    QStackedWidget* mStackWidget;
    LoginWidget* mLoginWidget;
    QWidget* mHomeWidget;
    JobWidget* mJobWidget;

};

#endif // MAINWINDOW_H
