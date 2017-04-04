#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMenuBar>
#include <QVBoxLayout>
#include <QTabWidget>
#include <QMessageBox>

#include "core.h"
#include "ui/loginwidget.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

    // Overriden methods
    void closeEvent(QCloseEvent *);


    //
    void restoreSettings();
    void writeSettings();



public slots:
    void about();
    void checkAuthent(QString login, QString password);

protected:
    void buildMenu();


    QMenuBar *mMenuBar;
    QTabWidget *mTabWidget;

    Core *mRegovar;
};

#endif // MAINWINDOW_H
