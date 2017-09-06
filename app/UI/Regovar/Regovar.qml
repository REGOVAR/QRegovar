pragma Singleton
import QtQuick 2.0
import Qt.labs.settings 1.0

import "../MainMenu"
import "../Pages"

QtObject 
{
    id: uiModel
    /*! This QML model is the global "view model" of the application
     *  It manage only data use for  the UI (like the selected entry in the main menu and so on
     *  The "True" model of the application is done in C++, see /Model/Regovar singleton
     *  accessible in the QML by the id "regovar"
     */

//    // Reload some value from Settings
//    Settings
//    {
//        property string themeUsed: "RegovarLight" // initial default value
//    }
//    Component.onDestruction:
//    {
//        settings.themeUsed = uiModel.themeUsed // store value choose by the user to restore it next time
//    }


    //! Collection of sub windows
    property var openAnalysisWindows;

    //! The theme applied to the UI
    property Style theme: Style {}

    //! Indicates if need to display help information's box in the UI
    property bool helpInfoBoxDisplayed: true
    
    //! Main menu model
    property MenuModel menuModel: MenuModel
    {
        model:  [
            { "icon": "a", "label": qsTr("Welcome"),      "page": "WelcomPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "z", "label": qsTr("Search"),       "page": "Browse/SearchPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "c", "label": qsTr("Project"),      "page": "", "sublevel": [
                { "icon": "c", "label": qsTr("Browser"),   "page": "Browse/ProjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "6", "label": "DPNI",           "page": "", "sublevel": [
                    { "label": qsTr("Summary"),        "page": "Project/SummaryPage.qml", "sublevel": []},
                    //{ "label": qsTr("Events"),        "page": "Project/EventsPage.qml", "sublevel": []},
                    { "label": qsTr("Analyses"),      "page": "Project/AnalysesPage.qml", "sublevel": []},
                    { "label": qsTr("Subjects"),      "page": "Project/SubjectsPage.qml", "sublevel": []},
                    { "label": qsTr("Files"),         "page": "Project/FilesPage.qml", "sublevel": []},
                    { "label": qsTr("Settings"),      "page": "Project/SettingsPage.qml", "sublevel": []}
                    ], "subindex": 0},
                ], "subindex": 0},
            { "icon": "b", "label": qsTr("Subject"),    "page": "", "sublevel": [
                { "icon": "z", "label": qsTr("Browser"), "page": "Browse/SubjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": "Michel Dupont","page": "", "sublevel": [
                    //{ "label": qsTr("Resume"),          "page": "Subject/ResumePage.qml", "sublevel": []},
                    { "label": qsTr("Informations"),    "page": "Subject/SettingsPage.qml", "sublevel": []},
                    { "label": qsTr("Phenotype"),       "page": "Subject/PhenotypesPage.qml", "sublevel": []},
                    //{ "label": qsTr("Characteristics"), "page": "Subject/CharacteristicsPage.qml", "sublevel": []},
                    { "label": qsTr("Samples"),         "page": "Subject/SamplesPage.qml", "sublevel": []},
                    { "label": qsTr("Analyses"),        "page": "Subject/AnalysesPage.qml", "sublevel": []},
                    { "label": qsTr("Files"),           "page": "Subject/FilesPage.qml", "sublevel": []},
                    //{ "label": qsTr("Events"),          "page": "Subject/EventsPage.qml", "sublevel": []}
                    ], "subindex": 0},
                ], "subindex": 0},
            { "icon": "d", "label": qsTr("Settings"),      "page": "",   "sublevel": [
                { "icon": "q", "label": qsTr("Panel"),     "page": "Settings/PanelsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "L", "label": qsTr("Pipeline"),  "page": "Settings/PipesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": qsTr("My profile"),"page": "Settings/ProfilePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "7", "label": qsTr("Server"),    "page": "Settings/ServerPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "}", "label": qsTr("Interface"), "page": "Settings/InterfacePage.qml", "sublevel": [], "subindex": -1},
                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help"),           "page": "", "sublevel": [
                { "icon": "e", "label": qsTr("User guide"), "page": "Help/UserGuidePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "e", "label": qsTr("Tutorials"),  "page": "Help/TutorialsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "f", "label": qsTr("About"),      "page": "Help/AboutPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "h", "label": qsTr("Close"),        "page": "@close",      "sublevel": [], "subindex": -1}//,
            //{ "icon": "~", "label": qsTr("DEBUG"),        "page": "Analysis/Filtering/FilteringPage.qml",      "sublevel": [], "subindex": -1}
        ]
    }
} 
