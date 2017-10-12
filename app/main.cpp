#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QtQml>

#include "Model/regovar.h" // include regovar singleton which wrap all models and is the interface with the server
#include "Model/framework/treemodel.h"
#include "Model/framework/treeitem.h"
#include "Model/project/project.h"
#include "Model/file/filesystemmodel.cpp"
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/analysis/pipeline/pipelineanalysis.h"
#include "Model/analysis/filtering/reference.h"


int main(int argc, char *argv[])
{
    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv); // use it to allow QtChart module use with QML

    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");

    // Register custom classes to use it with QML
    qmlRegisterUncreatableType<FileSystemModel>("org.regovar", 1, 0, "FileSystemModel", "Cannot create a FileSystemModel instance.");
    qmlRegisterType<TreeModel>("org.regovar", 1, 0, "TreeModel");
    qmlRegisterType<Annotation>("org.regovar", 1, 0, "AnnotationModel");
    qmlRegisterType<FilteringAnalysis>("org.regovar", 1, 0, "FilteringAnalysis");
    qmlRegisterType<PipelineAnalysis>("org.regovar", 1, 0, "PipelineAnalysis");
    qmlRegisterType<Sample>("org.regovar", 1, 0, "Sample");
    qmlRegisterType<Reference>("org.regovar", 1, 0, "Reference");
    qmlRegisterType<FieldColumnInfos>("org.regovar", 1, 0, "FieldColumnInfos");
    qmlRegisterType<QuickFilterField>("org.regovar", 1, 0, "QuickFilterField");
    qmlRegisterType<AdvancedFilterModel>("org.regovar", 1, 0, "AdvancedFilterModel");
    qmlRegisterType<User>("org.regovar", 1, 0, "User");
    qmlRegisterType<Project>("org.regovar", 1, 0, "Project");
    qmlRegisterType<AdminTableInfo>("org.regovar", 1, 0, "AdminTableInfo");




    QQmlApplicationEngine engine;

    // Init regovar model
    regovar->init();
    regovar->setQmlEngine(&engine);

    // Init filesystem model
    FileSystemModel* fsm = new FileSystemModel(&engine);
    fsm->setRootPath(QDir::rootPath()); // Crash with Ubuntu 16 - Gnome
    fsm->setResolveSymlinks(true);
    engine.rootContext()->setContextProperty("fileSystemModel", fsm);
    engine.rootContext()->setContextProperty("rootPathIndex", fsm->index(fsm->rootPath()));

    engine.rootContext()->setContextProperty("regovar", regovar);
    engine.addImportPath("qrc:/qml/");
    engine.load(QUrl(QLatin1String("qrc:/qml/MainWindow.qml")));

    app.setWindowIcon(QIcon(":/logo.png"));

    return app.exec();
}




