#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QSettings>
#include <QtQml>
#include <QtCore>
#include <QIcon>
//#include <QtWebEngine/qtwebengineglobal.h>

#include "Model/regovar.h" // include regovar singleton which wrap all models and is the interface with the server
#include "Model/framework/treemodel.h"
#include "Model/framework/treeitem.h"
#include "Model/framework/genericproxymodel.h"
#include "Model/project/project.h"
#include "Model/analysis/filtering/filteringanalysis.h"
#include "Model/analysis/pipeline/pipelineanalysis.h"
#include "Model/subject/reference.h"
#include "Model/subject/attribute.h"
#include "Model/tools/tool.h"
#include "Model/tools/toolparameter.h"
#include "Model/mainmenu/rootmenu.h"
#include "Model/mainmenu/menuentry.h"

#include "Widgets/VariantsTreeWidget/variantstreewidget.h"


int main(int argc, char *argv[])
{
    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv); // use it instead of QGuiApplication to allow QtChart module use with QML

    app.setApplicationName("Regovar");
    app.setOrganizationName("Regovar");
    app.setOrganizationDomain("regovar.org");
    app.setApplicationVersion("0.0.b");


    // Register custom classes to use it with QML: Regovar.Core
    qmlRegisterType<TreeModel>("Regovar.Core", 1, 0, "TreeModel");
    qmlRegisterType<GenericProxyModel>("Regovar.Core", 1, 0, "GenericProxyModel");

    qmlRegisterType<Annotation>("Regovar.Core", 1, 0, "AnnotationModel");
    qmlRegisterType<FilteringAnalysis>("Regovar.Core", 1, 0, "FilteringAnalysis");
    qmlRegisterType<PipelineAnalysis>("Regovar.Core", 1, 0, "PipelineAnalysis");
    qmlRegisterType<FieldColumnInfos>("Regovar.Core", 1, 0, "FieldColumnInfos");
    qmlRegisterType<QuickFilterField>("Regovar.Core", 1, 0, "QuickFilterField");
    qmlRegisterType<AdvancedFilterModel>("Regovar.Core", 1, 0, "AdvancedFilterModel");
    qmlRegisterType<Set>("Regovar.Core", 1, 0, "Set");

    qmlRegisterType<ProjectsManager>("Regovar.Core", 1, 0, "ProjectsManager");
    qmlRegisterType<SubjectsManager>("Regovar.Core", 1, 0, "SubjectsManager");
    qmlRegisterType<SamplesManager>("Regovar.Core", 1, 0, "SamplesManager");
    qmlRegisterType<AnalysesManager>("Regovar.Core", 1, 0, "AnalysesManager");
    qmlRegisterType<ToolsManager>("Regovar.Core", 1, 0, "ToolsManager");
    qmlRegisterType<PanelsManager>("Regovar.Core", 1, 0, "PanelsManager");

    qmlRegisterType<EventsListModel>("Regovar.Core", 1, 0, "EventsListModel");
    qmlRegisterType<FilesListModel>("Regovar.Core", 1, 0, "FilesListModel");
    qmlRegisterType<FilesTreeModel>("Regovar.Core", 1, 0, "FilesTreeModel");
    qmlRegisterType<PhenotypesListModel>("Regovar.Core", 1, 0, "PhenotypesListModel");

    qmlRegisterType<User>("Regovar.Core", 1, 0, "User");
    qmlRegisterType<Project>("Regovar.Core", 1, 0, "Project");
    qmlRegisterType<Subject>("Regovar.Core", 1, 0, "Subject");
    qmlRegisterType<Sample>("Regovar.Core", 1, 0, "Sample");
    qmlRegisterType<File>("Regovar.Core", 1, 0, "File");
    qmlRegisterType<Reference>("Regovar.Core", 1, 0, "Reference");
    qmlRegisterType<Attribute>("Regovar.Core", 1, 0, "Attribute");
    qmlRegisterType<Panel>("Regovar.Core", 1, 0, "Panel");
    qmlRegisterType<Event>("Regovar.Core", 1, 0, "Event");
    qmlRegisterType<Pipeline>("Regovar.Core", 1, 0, "Pipeline");
    qmlRegisterType<Phenotype>("Regovar.Core", 1, 0, "Phenotype");
    qmlRegisterType<Disease>("Regovar.Core", 1, 0, "Disease");

    qmlRegisterType<RemoteLogModel>("Regovar.Core", 1, 0, "RemoteLogModel");
    qmlRegisterType<AdminTableInfo>("Regovar.Core", 1, 0, "AdminTableInfo");
    qmlRegisterType<RootMenu>("Regovar.Core", 1, 0, "RootMenu");
    qmlRegisterType<MenuEntry>("Regovar.Core", 1, 0, "MenuEntry");
    qmlRegisterType<DynamicFormModel>("Regovar.Core", 1, 0, "DynamicFormModel");
    qmlRegisterType<DynamicFormFieldModel>("Regovar.Core", 1, 0, "DynamicFormFieldModel");
    // TODO: refacto with DynamicFormModel & DynamicFormFieldModel
    qmlRegisterType<Tool>("Regovar.Core", 1, 0, "Tool");
    qmlRegisterType<ToolParameter>("Regovar.Core", 1, 0, "ToolParameter");


    // Register custom classes to use it with QML: Regovar.Widget
    qmlRegisterType<VariantsTreeWidget>("Regovar.Widget", 1, 0, "VariantsTreeWidget");




    // Must be called before creating any webwidget/webqml
    //QtWebEngine::initialize();
    //qmlRegisterType<QQmlWebChannel>("Regovar.Core", 1, 0, "QQmlWebChannel");

    QQmlApplicationEngine engine;

    // Init regovar model
    regovar->init();
    regovar->setQmlEngine(&engine);

    engine.rootContext()->setContextProperty("regovar", regovar);
    engine.addImportPath("qrc:/qml/");
    engine.load(QUrl(QLatin1String("qrc:/qml/MainWindow.qml")));

    app.setWindowIcon(QIcon(":/logo.png"));

    return app.exec();
}




