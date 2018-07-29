QT += qml quick widgets websockets charts network

CONFIG += c++11 # qtquickcompiler

QMAKE_LFLAGS_RPATH=
QMAKE_LFLAGS=-Wl,-rpath,/opt/qregovar/lib

#Application version
VERSION_MAJOR = 0
VERSION_MINOR = 13
VERSION_BUILD = 1
DEFINES += "VERSION_MAJOR=$$VERSION_MAJOR"\
       "VERSION_MINOR=$$VERSION_MINOR"\
       "VERSION_BUILD=$$VERSION_BUILD"\
       "MIN_SYNC_DELAY=60"

#CONFIG(release, debug|release)
#{
#    QMAKE_CXXFLAGS += /MT
#}



HEADERS += \
    Model/framework/treeitem.h \
    Model/framework/treemodel.h \
    Model/framework/request.h \
    Model/analysis/analysis.h \
    Model/analysis/pipeline/pipelineanalysis.h \
    Model/analysis/filtering/advancedfilters/advancedfiltermodel.h \
    Model/analysis/filtering/advancedfilters/set.h \
    Model/analysis/filtering/filteringanalysis.h \
    Model/analysis/filtering/quickfilters/quickfiltermodel.h \
    Model/analysis/filtering/quickfilters/transmissionquickfilter.h \
    Model/analysis/filtering/quickfilters/quickfilterblockinterface.h \
    Model/analysis/filtering/annotation.h \
    Model/analysis/filtering/annotationstreemodel.h \
    Model/analysis/filtering/resultstreeitem.h \
    Model/analysis/filtering/resultstreemodel.h \
    Model/analysis/filtering/quickfilters/qualityquickfilter.h \
    Model/analysis/filtering/quickfilters/positionquickfilter.h \
    Model/analysis/filtering/quickfilters/typequickfilter.h \
    Model/analysis/filtering/quickfilters/frequencequickfilter.h \
    Model/analysis/filtering/quickfilters/insilicopredquickfilter.h \
    Model/analysis/filtering/fieldcolumninfos.h \
    Model/analysis/filtering/savedfilter.h \
    Model/file/file.h \
    Model/file/filestreemodel.h \
    Model/file/tusuploader.h \
    Model/project/project.h \
    Model/project/projectstreemodel.h \
    Model/subject/attribute.h \
    Model/subject/sample.h \
    Model/subject/subject.h \
    Model/admin.h \
    Model/regovar.h \
    Model/user/user.h \
    Model/user/userslistmodel.h \
    Model/subject/subjectsmanager.h \
    Model/subject/samplesmanager.h \
    Model/subject/reference.h \
    Model/file/filesmanager.h \
    Model/tools/toolparameter.h \
    Model/tools/tool.h \
    Model/tools/toolsmanager.h \
    Model/project/projectsmanager.h \
    Model/analysis/analysesmanager.h \
    Model/framework/networkmanager.h \
    Model/framework/networktask.h \
    Model/panel/panelsmanager.h \
    Model/panel/panel.h \
    Model/panel/panelstreemodel.h \
    Model/analysis/filtering/quickfilters/phenotypequickfilter.h \
    Model/analysis/filtering/quickfilters/panelquickfilter.h \
    Model/settings.h \
    Model/mainmenu/rootmenu.h \
    Model/mainmenu/menuentry.h \
    Model/framework/genericproxymodel.h \
    Widgets/VariantsTreeWidget/variantstreewidget.h \
    Model/analysis/filtering/filteringresult.h \
    Model/analysis/filtering/filteringresultcell.h \
    Model/phenotype/phenotypesmanager.h \
    Model/phenotype/phenotype.h \
    Model/event/event.h \
    Model/event/eventsmanager.h \
    Model/event/eventslistmodel.h \
    Model/pipeline/pipeline.h \
    Model/pipeline/pipelinesmanager.h \
    Model/pipeline/pipelineslistmodel.h \
    Model/framework/dynamicformmodel.h \
    Model/framework/dynamicformfieldmodel.h \
    Model/file/fileslistmodel.h \
    Model/analysis/remotelogmodel.h \
    Model/user/usersmanager.h \
    Model/phenotype/disease.h \
    Model/phenotype/hpodata.h \
    Model/phenotype/hpodatalistmodel.h \
    Model/phenotype/diseaseslistmodel.h \
    Model/phenotype/phenotypeslistmodel.h \
    Model/subject/subjectslistmodel.h \
    Model/analysis/analyseslistmodel.h \
    Model/panel/panelversion.h \
    Model/panel/panelentry.h \
    Model/panel/panelentrieslistmodel.h \
    Model/phenotype/gene.h \
    Model/framework/regovarresource.h \
    Model/panel/panelversionslistmodel.h \
    Model/phenotype/geneslistmodel.h \
    Model/subject/sampleslistmodel.h \
    Model/framework/jsonlistmodel.h \
    Model/panel/panelslistmodel.h \
    Model/serverTask/servertask.h \
    Model/serverTask/servertaskslistmodel.h

SOURCES += main.cpp \
    Model/framework/treeitem.cpp \
    Model/framework/treemodel.cpp \
    Model/framework/request.cpp \
    Model/analysis/analysis.cpp \
    Model/analysis/pipeline/pipelineanalysis.cpp \
    Model/analysis/filtering/filteringanalysis.cpp \
    Model/analysis/filtering/advancedfilters/advancedfiltermodel.cpp \
    Model/analysis/filtering/advancedfilters/set.cpp \
    Model/analysis/filtering/quickfilters/quickfiltermodel.cpp \
    Model/analysis/filtering/quickfilters/transmissionquickfilter.cpp \
    Model/analysis/filtering/quickfilters/quickfilterblockinterface.cpp \
    Model/analysis/filtering/annotation.cpp \
    Model/analysis/filtering/annotationstreemodel.cpp \
    Model/analysis/filtering/resultstreeitem.cpp \
    Model/analysis/filtering/resultstreemodel.cpp \
    Model/analysis/filtering/quickfilters/qualityquickfilter.cpp \
    Model/analysis/filtering/quickfilters/positionquickfilter.cpp \
    Model/analysis/filtering/quickfilters/typequickfilter.cpp \
    Model/analysis/filtering/quickfilters/frequencequickfilter.cpp \
    Model/analysis/filtering/quickfilters/insilicopredquickfilter.cpp \
    Model/analysis/filtering/fieldcolumninfos.cpp \
    Model/analysis/filtering/savedfilter.cpp \
    Model/file/file.cpp \
    Model/file/filestreemodel.cpp \
    Model/file/tusuploader.cpp \
    Model/project/project.cpp \
    Model/project/projectstreemodel.cpp \
    Model/subject/attribute.cpp \
    Model/subject/sample.cpp \
    Model/subject/subject.cpp \
    Model/admin.cpp \
    Model/regovar.cpp \
    Model/user/user.cpp \
    Model/user/userslistmodel.cpp \
    Model/subject/subjectsmanager.cpp \
    Model/subject/samplesmanager.cpp \
    Model/subject/reference.cpp \
    Model/file/filesmanager.cpp \
    Model/tools/toolparameter.cpp \
    Model/tools/tool.cpp \
    Model/tools/toolsmanager.cpp \
    Model/project/projectsmanager.cpp \
    Model/analysis/analysesmanager.cpp \
    Model/framework/networkmanager.cpp \
    Model/framework/networktask.cpp \
    Model/panel/panelsmanager.cpp \
    Model/panel/panel.cpp \
    Model/panel/panelstreemodel.cpp \
    Model/analysis/filtering/quickfilters/phenotypequickfilter.cpp \
    Model/analysis/filtering/quickfilters/panelquickfilter.cpp \
    Model/settings.cpp \
    Model/mainmenu/rootmenu.cpp \
    Model/mainmenu/menuentry.cpp \
    Model/framework/genericproxymodel.cpp \
    Widgets/VariantsTreeWidget/variantstreewidget.cpp \
    Model/analysis/filtering/filteringresult.cpp \
    Model/analysis/filtering/filteringresultcell.cpp \
    Model/phenotype/phenotypesmanager.cpp \
    Model/phenotype/phenotype.cpp \
    Model/event/event.cpp \
    Model/event/eventsmanager.cpp \
    Model/event/eventslistmodel.cpp \
    Model/pipeline/pipeline.cpp \
    Model/pipeline/pipelinesmanager.cpp \
    Model/pipeline/pipelineslistmodel.cpp \
    Model/framework/dynamicformmodel.cpp \
    Model/framework/dynamicformfieldmodel.cpp \
    Model/file/fileslistmodel.cpp \
    Model/analysis/remotelogmodel.cpp \
    Model/user/usersmanager.cpp \
    Model/phenotype/disease.cpp \
    Model/phenotype/hpodata.cpp \
    Model/phenotype/diseaseslistmodel.cpp \
    Model/phenotype/hpodatalistmodel.cpp \
    Model/phenotype/phenotypeslistmodel.cpp \
    Model/subject/subjectslistmodel.cpp \
    Model/analysis/analyseslistmodel.cpp \
    Model/panel/panelversion.cpp \
    Model/panel/panelentry.cpp \
    Model/panel/panelentrieslistmodel.cpp \
    Model/phenotype/gene.cpp \
    Model/framework/regovarresource.cpp \
    Model/panel/panelversionslistmodel.cpp \
    Model/phenotype/geneslistmodel.cpp \
    Model/subject/sampleslistmodel.cpp \
    Model/framework/jsonlistmodel.cpp \
    Model/panel/panelslistmodel.cpp \
    Model/serverTask/servertask.cpp \
    Model/serverTask/servertaskslistmodel.cpp


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/qregovar
!isEmpty(target.path): INSTALLS += target



#win32
#{
#    COPY_FROM_PATH=$$shell_path($$PWD/libs/win)
#    COPY_TO_PATH=$$shell_path($$OUT_PWD)
#    copydata.commands = $(COPY_DIR) $$COPY_FROM_PATH $$COPY_TO_PATH
#    first.depends = $(first) copydata
#    export(first.depends)
#    export(copydata.commands)
#    QMAKE_EXTRA_TARGETS += first copydata
#}
#else {
#    COPY_FROM_PATH=$$PWD/UI/
#    COPY_TO_PATH=$$OUT_PWD/UI/
#}



RESOURCES += \
    Assets/qrc.qrc \
    UI/qml.qrc

DISTFILES += \
    Assets/license.html
