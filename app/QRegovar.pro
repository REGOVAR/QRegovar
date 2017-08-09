QT += qml quick widgets

CONFIG += c++11


HEADERS += \
    Model/treeitem.h \
    Model/treemodel.h \
    Model/jsonmodel.h \
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
    Model/sample/sample.h

SOURCES += main.cpp \
    Model/treeitem.cpp \
    Model/treemodel.cpp \
    Model/jsonmodel.cpp \
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
    Model/sample/sample.cpp


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
    UI/Icons.ttf \
    UI/Framework/Button.qml \
    UI/Framework/CheckBox.qml \
    UI/Framework/ListViewItem.qml \
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
    UI/Pages/WelcomPage.qml \
    UI/Framework/qmldir \
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
    UI/MainMenu/MenuEntryL3.qml \
    UI/Framework/TreeView.qml \
    UI/Framework/ListView.qml \
    UI/Regovar/Themes/HalloweenTheme.js \
    UI/Regovar/Themes/HalloweenTheme.js \
    UI/Regovar/Themes/RegovarDarkTheme.js \
    UI/Regovar/Themes/RegovarLightTheme.js \
    UI/Dialogs/SelectFilesDialog.qml \
    UI/Framework/BusyIndicator.qml \
    UI/MainMenu/HeaderTabEntry.qml \
    UI/Pages/Analysis/Filtering/FilteringPage.qml \
    UI/Pages/Analysis/Filtering/Quickfilter/TransmissionQuickForm.qml \
    UI/Pages/Analysis/Filtering/QuickFilterPanel.qml \
    UI/Dialogs/CloseDialog.qml \
    UI/Dialogs/ErrorDialog.qml \
    UI/Pages/Browse/AnalysesPage.qml \
    UI/Pages/Browse/EventsPage.qml \
    UI/Pages/Browse/FilesPage.qml \
    UI/Pages/Browse/OmnisearchPage.qml \
    UI/Pages/Browse/ProjectsPage.qml \
    UI/Pages/Browse/SubjectsPage.qml \
    UI/Pages/Project/ProjectsPage.qml \
    UI/Framework/Box.qml \
    UI/Pages/Help/AboutPage.qml \
    UI/Pages/Help/TutorialsPage.qml \
    UI/Pages/Help/UserGuidePage.qml \
    UI/Pages/Settings/InterfacePage.qml \
    UI/Pages/Settings/PanelsPage.qml \
    UI/Pages/Settings/PipesPage.qml \
    UI/Pages/Settings/ProfilePage.qml \
    UI/Pages/Settings/ServerPage.qml \
    UI/Pages/Analysis/Filtering/ResumePage.qml \
    UI/Pages/Analysis/Filtering/SettingsAnnotationsDBPage.qml \
    UI/Pages/Analysis/Filtering/SettingsSamplesPage.qml \
    UI/Pages/Analysis/Filtering/SelectionsPage.qml \
    UI/Pages/Analysis/Filtering/SettingsInformationsPage.qml \
    UI/Framework/SwipeView.qml \
    UI/Pages/Help/AboutLicense.qml \
    UI/Framework/TextArea.qml \
    UI/Pages/Help/AboutInformations.qml \
    UI/Pages/Help/AboutCredits.qml



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

RESOURCES += \
    Assets/qrc.qrc

