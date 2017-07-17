#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QtQml>

#include "Model/regovarmodel.h" // include regovar singleton which wrap all models and is the interface with the server
#include "Model/treemodel.h"
#include "Model/treeitem.h"

int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");

    // Register custom classes to use it with QML
    qmlRegisterType<TreeModel>("org.regovar", 1, 0, "TreeModel");

    // Init model
    regovar->init();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("regovar", regovar);
    engine.load(QUrl(QLatin1String("UI/MainWindow.qml")));

    return app.exec();
}
