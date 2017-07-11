QT += qml quick

CONFIG += c++11

SOURCES += main.cpp


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

DISTFILES += \
    UI/Regovar.qml \
    UI/Regovar.qmlc \
    UI/Icons.ttf \
    UI/Framework/Button.qml \
    UI/Framework/CheckBox.qml \
    UI/Framework/ListViewItem.qml \
    UI/Framework/MyListView.qml \
    UI/Framework/ProgressBar.qml \
    UI/Framework/Switch.qml \
    UI/Framework/TextField.qml \
    UI/MainMenu/MainMenu.qml \
    UI/MainMenu/MenuEntryL1.qml \
    UI/MainMenu/MenuEntryL2.qml \
    UI/Pages/AboutPage.qml \
    UI/Pages/ClosePage.qml \
    UI/Pages/DisconnectPage.qml \
    UI/Pages/HelpPage.qml \
    UI/Pages/Login.qml \
    UI/Pages/ProjectPage.qml \
    UI/Pages/SettingsPage.qml \
    UI/Pages/SubjectPage.qml \
    UI/Pages/WelcomPage.qml \
    UI/Framework/qmldir \
    UI/GridView/GridHeader.qml \
    UI/GridView/GridView.qml \
    UI/GridView/GridViewItem.qml \
    UI/Regovar/qmldir \
    UI/Regovar/Regovar.qml \
    UI/Regovar/Style.qml \
    UI/MainWindow.qml \
    UI/Pages/Project/AnalysesPage.qml \
    UI/Pages/Project/EventsPage.qml \
    UI/Pages/Project/FilesPage.qml \
    UI/Pages/Project/ResumePage.qml \
    UI/Pages/Project/SettingsIndicatorsPage.qml \
    UI/Pages/Project/SettingsInformationsPage.qml \
    UI/Pages/Project/SettingsSharingPage.qml \
    UI/Pages/Project/SubjectsPage.qml \
    UI/MainMenu/MenuEntryL3.qml



win32 {
    COPY_FROM_PATH=$$shell_path($$PWD/UI)
    COPY_TO_PATH=$$shell_path($$OUT_PWD/UI)
}
else {
    COPY_FROM_PATH=$$PWD/UI/
    COPY_TO_PATH=$$OUT_PWD/UI/
}

copydata.commands = $(COPY_DIR) $$COPY_FROM_PATH $$COPY_TO_PATH
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata
