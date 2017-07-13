#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QtQml/qqml.h>

#include "Model/treemodel.h"
#include "Model/treemodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");

    // Register custom classes to use it with QML
    qmlRegisterType<TreeModel>("org.regovar", 1, 0, "TreeModel");



    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("UI/MainWindow.qml")));

    return app.exec();

}
