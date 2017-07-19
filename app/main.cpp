#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QtQml>

#include "Model/regovarmodel.h" // include regovar singleton which wrap all models and is the interface with the server
#include "Model/treemodel.h"
#include "Model/treeitem.h"
#include "Model/file/filesystemmodel.cpp"

int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");

    // Register custom classes to use it with QML
    qmlRegisterUncreatableType<DisplayFileSystemModel>("org.regovar", 1, 0, "FileSystemModel", "Cannot create a FileSystemModel instance.");
    qmlRegisterType<TreeModel>("org.regovar", 1, 0, "TreeModel");


    QQmlApplicationEngine engine;

    // Init regovar model
    regovar->init();

    // Init filesystem model
    QFileSystemModel* fsm = new DisplayFileSystemModel(&engine);
    fsm->setRootPath(QDir::homePath());
    fsm->setResolveSymlinks(true);
    engine.rootContext()->setContextProperty("fileSystemModel", fsm);
    engine.rootContext()->setContextProperty("rootPathIndex", fsm->index(fsm->rootPath()));

    engine.rootContext()->setContextProperty("regovar", regovar);
    engine.load(QUrl(QLatin1String("UI/MainWindow.qml")));

    return app.exec();
}




