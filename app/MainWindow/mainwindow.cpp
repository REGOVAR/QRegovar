#include "mainwindow.h"
#include "ui/projectview/projectwidget.h"
#include "ui/projectview/projecteditiondialog.h"
#include "ui/settingview/settingsdialog.h"
#include "ui/settingview/admindialog.h"
#include "ui/jobview/jobwidget.h"
#include "app.h"


// Constructor
MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    // init Regovar's core instance
    regovar->init();

    // construct widget
    mHomeWidget = buildHomeWidget();
    mLoginWidget = new LoginWidget(this);
    mStackWidget = new QStackedWidget(this);
    mJobWidget = new JobWidget(this);

    // add widget to the stack
    mStackWidget->addWidget(mLoginWidget);
    mStackWidget->addWidget(mHomeWidget);
    projectview::ProjectWidget* jobView = new projectview::ProjectWidget(this);
    jobView->setContentsMargins(0,0,0,0);
//    jobView->setProject(new ProjectModel());
    mStackWidget->addWidget(jobView);


    // DEBUG
    mStackWidget->addWidget(mJobWidget);

    //create connection
    connect(mLoginWidget, SIGNAL(accepted()), this, SLOT(loginUser()));
    connect(regovar, SIGNAL(loginSuccess()), this, SLOT(updateMainWindow()));
    connect(regovar, SIGNAL(loginFailed()), this, SLOT(displayLoginFailedError()));
    connect(regovar, SIGNAL(logoutSuccess()), this, SLOT(updateMainWindow()));

    // set stack to the central widget
    setCentralWidget(mStackWidget);

    // set current stack widget
    setWindowIcon(QIcon(":/img/regovar-logo-32.png"));
    restoreSettings();
    //updateMainWindow();

    mStackWidget->setCurrentWidget(mHomeWidget);
}

MainWindow::~MainWindow()
{
}



//
// MainWindow macro workflow (to init/restore view on start/login/logout events)
//

void MainWindow::writeSettings()
{
    QSettings settings;
    settings.beginGroup("MainWindow");
    settings.setValue("size", size());
    settings.setValue("pos", pos());
    settings.endGroup();
}


void MainWindow::restoreSettings()
{
    QSettings settings;
    settings.beginGroup("MainWindow");
    resize(settings.value("size", QSize(400, 400)).toSize());
    move(settings.value("pos", QPoint(200, 200)).toPoint());
    settings.endGroup();
}


void MainWindow::closeEvent(QCloseEvent *)
{
    writeSettings();
}


void MainWindow::updateMainWindow()
{
    if (!regovar->currentUser()->isValid())
    {
        // Anonymous user : display login form
        mStackWidget->setCurrentWidget(mLoginWidget);
    }
    else
    {
        // Loged in user : display
        mStackWidget->setCurrentWidget(mHomeWidget);
    }
}


QWidget* MainWindow::buildHomeWidget()
{
    QQuickView* view = new QQuickView();
    QWidget* container = QWidget::createWindowContainer(view, this);
    container->setMinimumSize(200, 200);
    container->setFocusPolicy(Qt::TabFocus);
    // on met le context avant de charger le code
    view->rootContext()->setContextProperty("regovar", regovar);
    view->rootContext()->setContextProperty("main", this);
    view->setSource(QUrl("qrc:/qml/regovar.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);

    return container;
}




void MainWindow::loginUser()
{
    QString login  = mLoginWidget->username();
    QString passw  = mLoginWidget->password();

    qDebug() << "DEBUG" << Q_FUNC_INFO << QString("CheckAuthent login:%1 pwd:%2").arg(login, passw);
    regovar->login(login, passw);
}


void MainWindow::displayLoginFailedError()
{
    mLoginWidget->loginFailed();
}


void MainWindow::logoutUser()
{
    regovar->logout();
}





//
// Menu action slots
//

void MainWindow::about()
{
    QMessageBox::about(this, tr("About Regovar"), tr("<b>Regovar</b> application is the best."));
}


void MainWindow::settings()
{
    SettingsDialog settings;
    settings.exec();
}
void MainWindow::admin()
{
    if(regovar->currentUser()->isAdmin())
    {
        AdminDialog adminDialog;
        adminDialog.exec();
    }
}
void MainWindow::newProject()
{
    if (regovar->currentUser()->role(Project) == Write)
    {
        ProjectEditionDialog projectDialog;
        projectDialog.exec();
    }
}




