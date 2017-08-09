#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QtQml>

#include "Model/regovar.h" // include regovar singleton which wrap all models and is the interface with the server
#include "Model/treemodel.h"
#include "Model/treeitem.h"
#include "Model/file/filesystemmodel.cpp"
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/analysis/filtering/quickfilters/transmissionquickfilter.h"
#include "Model/analysis/filtering/quickfilters/qualityquickfilter.h"
#include "Model/analysis/filtering/quickfilters/positionquickfilter.h"
#include "Model/analysis/filtering/quickfilters/typequickfilter.h"
#include "Model/analysis/filtering/quickfilters/frequencequickfilter.h"
#include "Model/analysis/filtering/quickfilters/insilicopredquickfilter.h"

int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");

    // Register custom classes to use it with QML
    qmlRegisterUncreatableType<FileSystemModel>("org.regovar", 1, 0, "FileSystemModel", "Cannot create a FileSystemModel instance.");
    qmlRegisterType<TreeModel>("org.regovar", 1, 0, "TreeModel");
    qmlRegisterType<Annotation>("org.regovar", 1, 0, "AnnotationModel");
    qmlRegisterType<FilteringAnalysis>("org.regovar", 1, 0, "FilteringAnalysis");
    qmlRegisterType<Sample>("org.regovar", 1, 0, "Sample");

//    qmlRegisterType<QuickFilterField>("org.regovar", 1, 0, "QuickFilterField");
//    qmlRegisterType<TransmissionQuickFilter>("org.regovar", 1, 0, "TransmissionQuickFilter");
//    qmlRegisterType<QualityQuickFilter>("org.regovar", 1, 0, "QualityQuickFilter");
//    qmlRegisterType<PositionQuickFilter>("org.regovar", 1, 0, "PositionQuickFilter");
//    qmlRegisterType<TypeQuickFilter>("org.regovar", 1, 0, "TypeQuickFilter");
//    qmlRegisterType<FrequenceQuickFilter>("org.regovar", 1, 0, "FrequenceQuickFilter");
//    qmlRegisterType<InSilicoPredQuickFilter>("org.regovar", 1, 0, "InSilicoPredQuickFilter");



    QQmlApplicationEngine engine;

    // Init regovar model
    regovar->init();
    regovar->setQmlEngine(&engine);

    // Init filesystem model
//    FileSystemModel* fsm = new FileSystemModel(&engine);
//    fsm->setRootPath(QDir::homePath());
//    fsm->setResolveSymlinks(true);
//    engine.rootContext()->setContextProperty("fileSystemModel", fsm);
//    engine.rootContext()->setContextProperty("rootPathIndex", fsm->index(fsm->rootPath()));

    engine.rootContext()->setContextProperty("regovar", regovar);
    engine.load(QUrl(QLatin1String("UI/MainWindow.qml")));

    app.setWindowIcon(QIcon(":/logo.png"));
    return app.exec();
}




