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
            { "icon": "z", "label": qsTr("Search"),       "page": "", "sublevel": [
                { "icon": "z", "label": qsTr("Search"),   "page": "Browse/SearchPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "c", "label": qsTr("Projects"), "page": "Browse/ProjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": qsTr("Subjects"), "page": "Browse/SubjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "H", "label": qsTr("Events"),   "page": "Browse/EventsPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "d", "label": qsTr("Settings"),     "page": "",   "sublevel": [
                { "icon": "q", "label": qsTr("Panel"),    "page": "Settings/PanelsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "L", "label": qsTr("Pipeline"), "page": "Settings/PipesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": qsTr("My pofile"),"page": "Settings/ProfilePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "¶", "label": qsTr("Server"),   "page": "Settings/ServerPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "}", "label": qsTr("Interface"),"page": "Settings/InterfacePage.qml", "sublevel": [], "subindex": -1},
                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help"),         "page": "", "sublevel": [
                { "icon": "e", "label": qsTr("User guide"), "page": "Help/UserGuidePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "e", "label": qsTr("Tutorials"),  "page": "Help/TutorialsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "f", "label": qsTr("About"),      "page": "Help/AboutPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "h", "label": qsTr("Close"),        "page": "@close",      "sublevel": [], "subindex": -1},
            { "icon": "~", "label": qsTr("DEBUG"),        "page": "Analysis/Filtering/FilteringPage.qml",      "sublevel": [], "subindex": -1}
        ]
    }
} 
