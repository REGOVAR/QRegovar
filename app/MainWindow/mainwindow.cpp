#include "mainwindow.h"
#include "ui/projectview/projectwidget.h"
#include "app.h"
#include "ui/settingview/settingsdialog.h"


// Constructor
MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    // init Regovar's core instance
    regovar->init();

    // construct widget
    mHomeTabWidget = buildHomeTab();
    mLoginWidget   = new LoginWidget(this);
    mStackWidget   = new QStackedWidget(this);
    mTabWidget     = new QTabWidget(this);
    mMenuBar       = new QMenuBar(this);

    // add widget to the stack
    mStackWidget->addWidget(mLoginWidget);
    mStackWidget->addWidget(mTabWidget);
    mTabWidget->addTab(mHomeTabWidget, tr("Home"));
    projectview::ProjectWidget* tab = new projectview::ProjectWidget(this);
    tab->setContentsMargins(0,0,0,0);
    tab->setProject(new ProjectModel());
    //tab->setStyleSheet("background-color: #ccc;");
    mTabWidget->addTab(tab, tr("Project"));

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
    updateMainWindow();
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
        mStackWidget->setCurrentWidget(mTabWidget);
    }
    buildMenu();
}


QWidget* MainWindow::buildHomeTab()
{
    QQuickView* view = new QQuickView();
    QWidget* container = QWidget::createWindowContainer(view, this);
    container->setMinimumSize(200, 200);
    container->setFocusPolicy(Qt::TabFocus);
    // on met le context avant de charger le code
    view->rootContext()->setContextProperty("regovar", regovar);
    view->rootContext()->setContextProperty("main", this);
    view->setSource(QUrl("qrc:/qml/home.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);

    return container;
}


void MainWindow::buildMenu()
{
    mMenuBar->clear();

    if (!regovar->currentUser()->isValid())
    {
        // Regovar menu
        QAction* homeAct = new QAction(tr("&Home"), this);
        homeAct->setShortcuts(QKeySequence::New);
        homeAct->setStatusTip(tr("Go to the start screen"));


        QAction* settingsAct = new QAction(tr("&Settings"), this);
        settingsAct->setStatusTip(tr("Edit Regovar application's settings"));
        connect(settingsAct, &QAction::triggered, this, &MainWindow::settings);

        QAction* fullscreenAct = new QAction(tr("&Fullscreen"), this);
        fullscreenAct->setShortcuts(QKeySequence::FullScreen);
        fullscreenAct->setStatusTip(tr("Display the application in fullscreen"));

        QAction* quitAct = new QAction(tr("&Quit"), this);
        quitAct->setShortcuts(QKeySequence::Quit);
        quitAct->setStatusTip(tr("Close the application"));
        connect(quitAct, &QAction::triggered, this, &MainWindow::close);

        QMenu* regovarMenu = mMenuBar->addMenu(tr("&Regovar"));
        regovarMenu->addAction(homeAct);
        regovarMenu->addAction(fullscreenAct);
        regovarMenu->addSeparator();
        regovarMenu->addAction(settingsAct);
        regovarMenu->addSeparator();
        regovarMenu->addAction(quitAct);

        // Help menu
        QAction* beginnerGuideAct = new QAction(tr("&Beginner's guide"), this);
        beginnerGuideAct->setStatusTip(tr("Watch the beginner's guide (online video ~5min)"));

        QAction* tutorialsAct = new QAction(tr("&Tutorials"), this);
        tutorialsAct->setStatusTip(tr("Online's tutorials"));

        QAction* aboutAct = new QAction(tr("&About Regovar"), this);
        aboutAct->setStatusTip(tr("Informations about the application"));
        connect(aboutAct, &QAction::triggered, this, &MainWindow::about);

        QMenu* helpMenu = mMenuBar->addMenu(tr("&Help"));
        helpMenu->addAction(beginnerGuideAct);
        helpMenu->addAction(tutorialsAct);
        helpMenu->addAction(fullscreenAct);
        helpMenu->addSeparator();
        helpMenu->addAction(aboutAct);
    }
    else
    {

        // Regovar menu
        QAction* homeAct = new QAction(tr("&Home"), this);
        homeAct->setShortcuts(QKeySequence::New);
        homeAct->setStatusTip(tr("Go to the start screen"));

        QAction* myProfileAct = new QAction(tr("&My profile"), this);
        myProfileAct->setStatusTip(tr("Edit my profile"));

        QAction* settingsAct = new QAction(tr("&Settings"), this);
        settingsAct->setStatusTip(tr("Edit Regovar application's settings"));
        connect(settingsAct, &QAction::triggered, this, &MainWindow::settings);

        QAction* fullscreenAct = new QAction(tr("&Fullscreen"), this);
        fullscreenAct->setShortcuts(QKeySequence::FullScreen);
        fullscreenAct->setStatusTip(tr("Display the application in fullscreen"));

        QAction* logoutAct = new QAction(tr("&Logout"), this);
        logoutAct->setStatusTip(tr("Close the application"));
        connect(logoutAct, &QAction::triggered, this, &MainWindow::logoutUser);

        QAction* quitAct = new QAction(tr("&Quit"), this);
        quitAct->setShortcuts(QKeySequence::Quit);
        quitAct->setStatusTip(tr("Close the application"));
        connect(quitAct, &QAction::triggered, this, &MainWindow::close);

        QMenu* regovarMenu = mMenuBar->addMenu(tr("&Regovar"));
        regovarMenu->addAction(homeAct);
        regovarMenu->addAction(fullscreenAct);
        regovarMenu->addSeparator();
        regovarMenu->addAction(myProfileAct);
        regovarMenu->addAction(settingsAct);
        regovarMenu->addSeparator();
        regovarMenu->addAction(logoutAct);
        regovarMenu->addAction(quitAct);

        // Projects
        if (regovar->currentUser()->role(Project) >= Read)
        {
            QMenu* projectMenu = mMenuBar->addMenu(tr("&Project"));
            if (regovar->currentUser()->role(Project) == Write)
            {
                QAction* newProjAct = new QAction(tr("&New project"), this);
                newProjAct->setStatusTip(tr("Create a new project"));
                projectMenu->addAction(newProjAct);
            }
            QAction* browseProjAct = new QAction(tr("&Open project"), this);
            browseProjAct->setStatusTip(tr("Browse and open existing projects"));
            projectMenu->addAction(browseProjAct);


            // Subjects
            QMenu* subjectMenu = mMenuBar->addMenu(tr("&Subject"));
            if (regovar->currentUser()->role(Project) == Write)
            {
                QAction* newSubjAct = new QAction(tr("&New subject"), this);
                newSubjAct->setStatusTip(tr("Create a new subject"));
                subjectMenu->addAction(newSubjAct);
            }
            QAction* browseSubjAct = new QAction(tr("&Open project"), this);
            browseSubjAct->setStatusTip(tr("Browse and open existing subjects"));
            subjectMenu->addAction(browseSubjAct);


            // Statistics
            mMenuBar->addMenu(tr("&Statistics"));
        }

        // TODO : loading "modules" dynamicaly from library ?

        // Administration Menu
        if (regovar->currentUser()->isAdmin())
        {
            mMenuBar->addMenu(tr("&Administration"));
        }


        // Help menu
        QAction* beginnerGuideAct = new QAction(tr("&Beginner's guide"), this);
        beginnerGuideAct->setStatusTip(tr("Watch the beginner's guide (online video ~5min)"));

        QAction* tutorialsAct = new QAction(tr("&Tutorials"), this);
        tutorialsAct->setStatusTip(tr("Online's tutorials"));

        QAction* aboutAct = new QAction(tr("&About Regovar"), this);
        aboutAct->setStatusTip(tr("Informations about the application"));
        connect(aboutAct, &QAction::triggered, this, &MainWindow::about);

        QMenu* helpMenu = mMenuBar->addMenu(tr("&Help"));
        helpMenu->addAction(beginnerGuideAct);
        helpMenu->addAction(tutorialsAct);
        helpMenu->addAction(fullscreenAct);
        helpMenu->addSeparator();
        helpMenu->addAction(aboutAct);
    }

    // Display the menu in the main window
    setMenuBar(mMenuBar);
}


void MainWindow::loginUser()
{
    QString login  = mLoginWidget->username();
    QString passw  = mLoginWidget->password();

    qDebug() << tr("checkAuthent login:%1 pwd:%2").arg(login, passw);
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
    QMessageBox::about(this, tr("About Regovar"), tr("<b>Regovar</b> application is the best. "));
}


void MainWindow::settings()
{
    SettingsDialog settings;
    settings.exec();
}









