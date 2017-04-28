#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMenuBar>
#include <QVBoxLayout>
#include <QTabWidget>
#include <QMessageBox>
#include <QtWidgets>
#include <QQuickView>
#include <QQmlContext>

#include "regovar.h"
#include "ui/loginwidget.h"

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
    QWidget* buildHomeTab();


    QMenuBar* mMenuBar = nullptr;

    // Widget containers
    QStackedWidget* mStackWidget;
    QTabWidget* mTabWidget;
    LoginWidget* mLoginWidget;
    QWidget* mHomeTabWidget;

};

#endif // MAINWINDOW_H
