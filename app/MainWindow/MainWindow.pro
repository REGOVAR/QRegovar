#-------------------------------------------------
#
# Project created by QtCreator 2017-04-03T12:17:17
#
#-------------------------------------------------

QT       += core gui network qml quick

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = MainWindow
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0



SOURCES += main.cpp\
        mainwindow.cpp \
    ui/loginwidget.cpp \
    app.cpp \
    ui/projectview/resumewidget.cpp \
    ui/projectview/projectsbrowserwidget.cpp \
    ui/projectview/projectwidget.cpp \
    ui/settingview/abstractsettingswidget.cpp \
    ui/settingview/settingsdialog.cpp \
    ui/settingview/settingpanels/myprofilewidget.cpp \
    ui/settingview/admindialog.cpp \
    ui/settingview/adminpanels/userslistwidget.cpp \
    ui/settingview/adminpanels/userlistviewmodel.cpp \
    ui/projectview/eventlistviewmodel.cpp \
    ui/settingview/adminpanels/usereditingdialog.cpp \
    ui/projectview/projecteditiondialog.cpp \
    ui/jobview/jobwidget.cpp \
    ui/jobview/joblistmodel.cpp \
    ui/jobview/joblistview.cpp \
    ui/jobview/jobview.cpp \
    ui/jobview/abstractjobviewer.cpp \
    ui/jobview/infojobviewer.cpp

HEADERS  += mainwindow.h \
    ui/loginwidget.h \
    app.h \
    ui/projectview/resumewidget.h \
    ui/projectview/projectsbrowserwidget.h \
    ui/projectview/projectwidget.h \
    ui/settingview/settingsdialog.h \
    ui/settingview/abstractsettingswidget.h \
    ui/settingview/settingpanels/myprofilewidget.h \
    ui/settingview/admindialog.h \
    ui/settingview/adminpanels/userslistwidget.h \
    ui/settingview/adminpanels/userlistviewmodel.h \
    ui/projectview/eventlistviewmodel.h \
    ui/settingview/adminpanels/usereditingdialog.h \
    ui/projectview/projecteditiondialog.h \
    ui/jobview/jobwidget.h \
    ui/jobview/joblistmodel.h \
    ui/jobview/joblistview.h \
    ui/jobview/jobview.h \
    ui/jobview/abstractjobviewer.h \
    ui/jobview/infojobviewer.h

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../Core/release/ -lCore
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../Core/debug/ -lCore
else:unix: LIBS += -L$$OUT_PWD/../Core/ -lCore

INCLUDEPATH += $$PWD/../Core
DEPENDPATH += $$PWD/../Core

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../Core/release/libCore.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../Core/debug/libCore.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../Core/release/Core.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../Core/debug/Core.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../Core/libCore.a

RESOURCES += \
    resources.qrc

include("../libs/QtAwesome/QtAwesome.pri")
