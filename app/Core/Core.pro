#-------------------------------------------------
#
# Project created by QtCreator 2017-04-03T12:33:11
#
#-------------------------------------------------

QT       += network


TARGET = Core
TEMPLATE = lib
CONFIG += staticlib

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    tools/request.cpp \
    managers/restapimanager.cpp \
    model/subject.cpp \
    model/analysis.cpp \
    model/job.cpp \
    model/file.cpp \
    model/task.cpp \
    model/pipeline.cpp \
    model/analysistemplate.cpp \
    model/reference.cpp \
    model/annotationdatabase.cpp \
    model/annotationfield.cpp \
    model/sample.cpp \
    model/variant.cpp \
    model/event.cpp \
    regovar.cpp \
    model/projectmodel.cpp \
    model/usermodel.cpp \
    model/resourcemodel.cpp

HEADERS += \
    tools/request.h \
    managers/restapimanager.h \
    model/subject.h \
    model/analysis.h \
    model/job.h \
    model/file.h \
    model/task.h \
    model/pipeline.h \
    model/analysistemplate.h \
    model/reference.h \
    model/annotationdatabase.h \
    model/annotationfield.h \
    model/sample.h \
    model/variant.h \
    model/event.h \
    regovar.h \
    model/projectmodel.h \
    model/usermodel.h \
    model/resourcemodel.h
unix {
    target.path = /usr/lib
    INSTALLS += target
}
