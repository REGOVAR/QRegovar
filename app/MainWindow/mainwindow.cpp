#include "mainwindow.h"


#include "tools/request.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    // Get Regovar's core instance
    mRegovar = Core::i();
    mRegovar->init();

    // Init HMI
    buildMenu();

    mTabWidget = new QTabWidget(parent);
    mTabWidget->addTab(new QWidget(), tr("Home"));

    LoginWidget *authent = new LoginWidget(parent);
    connect( authent,
             SIGNAL(acceptLogin(QString&,QString&,int&)),
             this,
             SLOT(checkAuthent(QString&,QString&)));
    setCentralWidget(authent);


    restoreSettings();

}

MainWindow::~MainWindow()
{

}





void MainWindow::writeSettings()
{
    mRegovar->settings()->beginGroup("MainWindow");
    mRegovar->settings()->setValue("size", size());
    mRegovar->settings()->setValue("pos", pos());
    mRegovar->settings()->endGroup();
}

void MainWindow::restoreSettings()
{
    mRegovar->settings()->beginGroup("MainWindow");
    resize(mRegovar->settings()->value("size", QSize(400, 400)).toSize());
    move(mRegovar->settings()->value("pos", QPoint(200, 200)).toPoint());
    mRegovar->settings()->endGroup();
}


void MainWindow::buildMenu()
{

    mMenuBar = new QMenuBar(0);

    // Regovar menu
    QAction *homeAct = new QAction(tr("&Home"), this);
    homeAct->setShortcuts(QKeySequence::New);
    homeAct->setStatusTip(tr("Go to the start screen"));

    QAction *myProfileAct = new QAction(tr("&My profile"), this);
    myProfileAct->setStatusTip(tr("Edit my profile"));

    QAction *settingsAct = new QAction(tr("&Settings"), this);
    settingsAct->setStatusTip(tr("Edit Regovar application's settings"));

    QAction *fullscreenAct = new QAction(tr("&Fullscreen"), this);
    fullscreenAct->setShortcuts(QKeySequence::FullScreen);
    fullscreenAct->setStatusTip(tr("Display the application in fullscreen"));

    QAction *quitAct = new QAction(tr("&Quit"), this);
    quitAct->setShortcuts(QKeySequence::Quit);
    quitAct->setStatusTip(tr("Close the application"));

    QMenu *regovarMenu = mMenuBar->addMenu(tr("&Regovar"));
    regovarMenu->addAction(homeAct);
    regovarMenu->addAction(fullscreenAct);
    regovarMenu->addSeparator();
    regovarMenu->addAction(myProfileAct);
    regovarMenu->addAction(settingsAct);
    regovarMenu->addSeparator();
    regovarMenu->addAction(quitAct);


    // TODO : loading "module menu" dynamicaly from library
//    menuBar->addMenu(tr("&Project"));
//    menuBar->addMenu(tr("&Subject"));
//    menuBar->addMenu(tr("&Pipeline"));

    // TODO : these generics menus may be complete by dynamic module
//    menuBar->addMenu(tr("&Statistics"));
//    menuBar->addMenu(tr("&Tools"));
//    menuBar->addMenu(tr("&Administration"));

    // Help menu
    QAction *beginnerGuideAct = new QAction(tr("&Beginner's guide"), this);
    beginnerGuideAct->setStatusTip(tr("Watch the beginner's guide (online video ~5min)"));

    QAction *tutorialsAct = new QAction(tr("&Tutorials"), this);
    tutorialsAct->setStatusTip(tr("Online's tutorials"));

    QAction *aboutAct = new QAction(tr("&About Regovar"), this);
    aboutAct->setStatusTip(tr("Informations about the application"));
    connect(aboutAct, &QAction::triggered, this, &MainWindow::about);

    QMenu *helpMenu = mMenuBar->addMenu(tr("&Help"));
    helpMenu->addAction(beginnerGuideAct);
    helpMenu->addAction(tutorialsAct);
    helpMenu->addAction(fullscreenAct);
    helpMenu->addSeparator();
    helpMenu->addAction(aboutAct);


    // Display the menu in the main window
    setMenuBar(mMenuBar);
}






void MainWindow::about()
{
    // TEST connect & lamda expression
//    Request* test = Request::get("/ref");
//    connect(test, Request::jsonReceived, [](const QJsonDocument& json)
//    {
//        qDebug() << "salut !";
//    });
    QMessageBox::about(this, tr("About Regovar"),
        tr("<b>Regovar</b> application is the best. "
           "As you can see with this perfect dialog box."));
}

void MainWindow::checkAuthent(QString login, QString password)
{
    QMessageBox::about(this, tr("Authent Success"),
        tr("Hello <b>%1</b>. You password is \"%2\" ! ... oups it's supposed to be a secret :P\n===\n").arg(login, password) );
}

















void MainWindow::closeEvent(QCloseEvent *)
{
    writeSettings();
}
