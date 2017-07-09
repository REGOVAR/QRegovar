#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("UI/Regovar.qml")));

    return app.exec();

}
