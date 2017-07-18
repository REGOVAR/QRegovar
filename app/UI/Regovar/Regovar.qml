pragma Singleton
import QtQuick 2.0
import Qt.labs.settings 1.0
import "../Pages"

QtObject 
{
    id: uiModel
    /*! This QML model is the global "view model" of the application
     *  It manage only data use for  the UI (like the selected entry in the main menu and so on
     *  The "True" model of the application is done in C++, see /Model/RegovarModel singleton
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


    //! The theme applied to the UI
    property string themeUsed: "" //settings.themeUsed
    property Style theme: Style
    {
        load: uiModel.themeUsed
    }



    
    //! Main menu model
    property QtObject mainMenu: QtObject
    {
        property int selectedMainIndex: 0
        property int selectedSubIndex: -1
        property int selectedSubSubIndex: -1

        property bool collapseMenu: false

        property bool displaySubLevel: false
        property bool displaySubLevelCurrent: false // to store current state when need to quickly/temporarly switch the level2 display on mousehover
        
        
        property var model:  [
            { "icon": "a", "label": qsTr("Welcome"),      "page": "WelcomPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "c", "label": qsTr("Project"),      "page": "ProjectPage.qml", "sublevel": [
                { "icon": "j", "label": qsTr("Resume"),   "page": "Project/ResumePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "H", "label": qsTr("Events"),   "page": "Project/EventsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": qsTr("Subjects"), "page": "Project/SubjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "I", "label": qsTr("Analyses"), "page": "Project/AnalysesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "O", "label": qsTr("Files"),    "page": "Project/FilesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "d", "label": qsTr("Settings"), "page": "Project/SettingsInformationsPage.qml", "sublevel": [
                    { "label": qsTr("Informations"),      "page": "Project/SettingsInformationsPage.qml", "sublevel": []},
                    { "label": qsTr("Indicators"),        "page": "Project/SettingsIndicatorsPage.qml", "sublevel": []},
                    { "label": qsTr("Sharing"),           "page": "Project/SettingsSharingPage.qml", "sublevel": []},
                    ], "subindex": 0}
                ], "subindex": -1},
            { "icon": "b", "label": qsTr("Subject"),      "page": "SubjectPage.qml",    "sublevel": [], "subindex": -1},
            { "icon": "d", "label": qsTr("Settings"),     "page": "SettingsPage.qml",   "sublevel": [], "subindex": -1},
            { "icon": "e", "label": qsTr("Help"),         "page": "HelpPage.qml",       "sublevel": [], "subindex": -1},
            { "icon": "f", "label": qsTr("About"),        "page": "AboutPage.qml",      "sublevel": [], "subindex": -1},
            { "icon": "g", "label": qsTr("Disconnect"),   "page": "DisconnectPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "h", "label": qsTr("Close"),        "page": "ClosePage.qml",      "sublevel": [], "subindex": -1}
        ]
        
        property string mainTitle: model[selectedMainIndex]["label"]
        onSelectedMainIndexChanged:
        {
            // When selecting a main entry, Restore selected sublevel
            selectedSubIndex = model[selectedMainIndex]["subindex"]
            // Update main title according to the selected section
            mainTitle = model[selectedMainIndex]["label"]
        }
        onSelectedSubIndexChanged:
        {
            // Store selected subindex to be able to restore it next
            model[selectedMainIndex]["subindex"] = selectedSubIndex
        }
    }
} 
