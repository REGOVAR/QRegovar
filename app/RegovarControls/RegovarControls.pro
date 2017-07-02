QT += qml

TARGET = RegovarControlsPlugins
TEMPLATE = lib
DESTDIR    = $$OUT_PWD/../RegovarControls/
CONFIG += c++11 plugin

SOURCES += \
    regovarcontrolsplugin.cpp \
    showcase.cpp

RESOURCES +=

# Additional import path used to resolve QML modules in Qt Creator's code model
QML2_IMPORT_PATH =

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

DISTFILES += \
    RegovarControls/qmldir \
    RegovarControls/Button.qml \
    RegovarControls/CheckBox.qml \
    RegovarControls/ProgressBar.qml \
    RegovarControls/Style.qml \
    RegovarControls/Switch.qml \
    RegovarControls/TextField.qml \
    RegovarControls/ListView.qml \
    RegovarControls/ListViewItem.qml

HEADERS += \
    regovarcontrolsplugin.h \
    showcase.h

#DESTDIR = $$OUT_PWD/../RegovarControls
#copydata.commands = $(COPY_DIR) $$PWD/RegovarControls/ $$OUT_PWD/..
#first.depends = $(first) copydata
#export(first.depends)
#export(copydata.commands)
#QMAKE_EXTRA_TARGETS += first copydata

win32 {
    COPY_FROM_PATH=$$shell_path($$PWD/RegovarControls)
    COPY_TO_PATH=$$shell_path($$OUT_PWD/../RegovarControls)
}
else {
    COPY_FROM_PATH=$$PWD/RegovarControls/
    COPY_TO_PATH=$$OUT_PWD/..
}

copydata.commands = $(COPY_DIR) $$COPY_FROM_PATH $$COPY_TO_PATH
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata


