QT += qml quick widgets websockets

CONFIG += c++11

#Application version
VERSION_MAJOR = 0
VERSION_MINOR = 2
VERSION_BUILD = 0
DEFINES += "VERSION_MAJOR=$$VERSION_MAJOR"\
       "VERSION_MINOR=$$VERSION_MINOR"\
       "VERSION_BUILD=$$VERSION_BUILD"





HEADERS += \
    Model/treeitem.h \
    Model/treemodel.h \
    Model/request.h \
    Model/file/filesystemmodel.h \
    Model/file/tusuploader.h \
    Model/analysis/filtering/quickfilters/quickfiltermodel.h \
    Model/analysis/filtering/quickfilters/transmissionquickfilter.h \
    Model/analysis/filtering/quickfilters/quickfilterblockinterface.h \
    Model/analysis/filtering/annotation.h \
    Model/analysis/filtering/annotationstreeitem.h \
    Model/analysis/filtering/annotationstreemodel.h \
    Model/analysis/filtering/resultstreeitem.h \
    Model/analysis/filtering/resultstreemodel.h \
    Model/file/file.h \
    Model/file/filestreeitem.h \
    Model/file/filestreemodel.h \
    Model/project/project.h \
    Model/project/projectstreeitem.h \
    Model/project/projectstreemodel.h \
    Model/regovar.h \
    Model/analysis/analysis.h \
    Model/analysis/filtering/filteringanalysis.h \
    Model/sample/sample.h \
    Model/analysis/filtering/quickfilters/qualityquickfilter.h \
    Model/analysis/filtering/quickfilters/positionquickfilter.h \
    Model/analysis/filtering/quickfilters/typequickfilter.h \
    Model/analysis/filtering/quickfilters/frequencequickfilter.h \
    Model/analysis/filtering/quickfilters/insilicopredquickfilter.h \
    Model/analysis/filtering/fieldcolumninfos.h \
    Model/analysis/filtering/remotesampletreeitem.h \
    Model/analysis/filtering/remotesampletreemodel.h \
    Model/analysis/pipeline/pipelineanalysis.h \
    Model/analysis/filtering/reference.h \
    Model/analysis/filtering/advancedfilters/advancedfiltermodel.h

SOURCES += main.cpp \
    Model/treeitem.cpp \
    Model/treemodel.cpp \
    Model/request.cpp \
    Model/file/filesystemmodel.cpp \
    Model/file/tusuploader.cpp \
    Model/analysis/filtering/quickfilters/quickfiltermodel.cpp \
    Model/analysis/filtering/quickfilters/transmissionquickfilter.cpp \
    Model/analysis/filtering/quickfilters/quickfilterblockinterface.cpp \
    Model/analysis/filtering/annotation.cpp \
    Model/analysis/filtering/annotationstreeitem.cpp \
    Model/analysis/filtering/annotationstreemodel.cpp \
    Model/analysis/filtering/resultstreeitem.cpp \
    Model/analysis/filtering/resultstreemodel.cpp \
    Model/file/file.cpp \
    Model/file/filestreeitem.cpp \
    Model/file/filestreemodel.cpp \
    Model/project/project.cpp \
    Model/project/projectstreeitem.cpp \
    Model/project/projectstreemodel.cpp \
    Model/regovar.cpp \
    Model/analysis/analysis.cpp \
    Model/analysis/filtering/filteringanalysis.cpp \
    Model/sample/sample.cpp \
    Model/analysis/filtering/quickfilters/qualityquickfilter.cpp \
    Model/analysis/filtering/quickfilters/positionquickfilter.cpp \
    Model/analysis/filtering/quickfilters/typequickfilter.cpp \
    Model/analysis/filtering/quickfilters/frequencequickfilter.cpp \
    Model/analysis/filtering/quickfilters/insilicopredquickfilter.cpp \
    Model/analysis/filtering/fieldcolumninfos.cpp \
    Model/analysis/filtering/remotesampletreeitem.cpp \
    Model/analysis/filtering/remotesampletreemodel.cpp \
    Model/analysis/pipeline/pipelineanalysis.cpp \
    Model/analysis/filtering/reference.cpp \
    Model/analysis/filtering/advancedfilters/advancedfiltermodel.cpp


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
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target



#win32 {
#    COPY_FROM_PATH=$$shell_path($$PWD/UI)
#    COPY_TO_PATH=$$shell_path($$OUT_PWD/UI)
#}
#else {
#    COPY_FROM_PATH=$$PWD/UI/
#    COPY_TO_PATH=$$OUT_PWD/UI/
#}

#copydata.commands = $(COPY_DIR) $$COPY_FROM_PATH $$COPY_TO_PATH
#first.depends = $(first) copydata
#export(first.depends)
#export(copydata.commands)
#QMAKE_EXTRA_TARGETS += first copydata

RESOURCES += \
    Assets/qrc.qrc \
    UI/qml.qrc

