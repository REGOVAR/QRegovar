pragma Singleton
import QtQuick 2.0
import Qt.labs.settings 1.0
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


    //! The theme applied to the UI
    property Style theme: Style {}

    //! Indicates if need to display help information's box in the UI
    property bool helpInfoBoxDisplayed: true
    
    //! Main menu model
    property QtObject mainMenu: QtObject
    {
        //! Menu page index contains the three levels of the menu
        property var selectedIndex: [0, -1, -1]

        property bool menuCollapsed: false

        property bool subLevelPanelDisplayed: false
        property bool _subLevelPanelDisplayed: false // to store current state when need to quickly/temporarly switch the level2 display on mousehover
        
        
        property var model:  [
            { "icon": "a", "label": qsTr("Welcome"),      "page": "WelcomPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "z", "label": qsTr("Search"),       "page": "", "sublevel": [
                { "icon": "z", "label": qsTr("Search"),   "page": "Browse/OmnisearchPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "c", "label": qsTr("Projects"), "page": "Browse/ProjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": qsTr("Subjects"), "page": "Browse/SubjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "H", "label": qsTr("Events"),   "page": "Browse/EventsPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "I", "label": qsTr("Analysis"),     "page": "", "sublevel": [
                { "icon": "j", "label": qsTr("Resume"),   "page": "Analysis/Filtering/ResumePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "d", "label": qsTr("Settings"), "page": "", "sublevel": [
                    { "label": qsTr("Informations"),      "page": "Analysis/Filtering/SettingsInformationsPage.qml", "sublevel": []},
                    { "label": qsTr("Samples"),           "page": "Analysis/Filtering/SettingsSamplesPage.qml", "sublevel": []},
                    { "label": qsTr("Annotations DB"),    "page": "Analysis/Filtering/SettingsAnnotationsDBPage.qml", "sublevel": []},
                    ], "subindex": 0},
                { "icon": "3", "label": qsTr("Filtering"), "page": "Analysis/Filtering/FilteringPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "o", "label": qsTr("Selection"), "page": "Analysis/Filtering/SelectionsPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "d", "label": qsTr("Settings"),      "page": "",   "sublevel": [
                { "icon": "q", "label": qsTr("Panel"),     "page": "Settings/PanelsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "L", "label": qsTr("Pipeline"),  "page": "Settings/PipesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": qsTr("My profile"),"page": "Settings/ProfilePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "¶", "label": qsTr("Server"),    "page": "Settings/ServerPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "}", "label": qsTr("Interface"), "page": "Settings/InterfacePage.qml", "sublevel": [], "subindex": -1},
                ], "subindex": 0},
            { "icon": "e", "label": qsTr("Help"),           "page": "", "sublevel": [
                { "icon": "e", "label": qsTr("User guide"), "page": "Help/UserGuidePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "e", "label": qsTr("Tutorials"),  "page": "Help/TutorialsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "f", "label": qsTr("About"),      "page": "Help/AboutPage.qml", "sublevel": [], "subindex": -1}
                ], "subindex": 0},
            { "icon": "h", "label": qsTr("Close"),        "page": "@close",      "sublevel": [], "subindex": -1},
            { "icon": "~", "label": qsTr("DEBUG"),        "page": "Analysis/Filtering/FilteringPage.qml",      "sublevel": [], "subindex": -1}
        ]
        
        property string mainTitle: model[selectedMainIndex]["label"]
        onSelectedIndexChanged:
        {
            // Store selected subindexes to be able to restore it next
            var lvl0 = selectedIndex[0];
            var lvl1 = selectedIndex[1];
            var lvl2 = selectedIndex[2];
            model[lvl0]["subindex"] = lvl1;
            if (lvl1 >= 0)
            {
                model[lvl0]["sublevel"][lvl1]["subindex"] = lvl2;
            }

            // Update main title according to the selected section
            mainTitle = model[lvl0]["label"];
        }

        // Update selectedIndex property according to the model
        function select(level, index)
        {
            var lvl0 = -1;
            var lvl1 = -1;
            var lvl2 = -1;

            if(level === 0)
            {
                lvl0 = index;
                lvl1 = model[lvl0]["subindex"];
                if (lvl1 >= 0)
                {
                    lvl2 = model[lvl0]["sublevel"][lvl1]["subindex"];
                }
            }
            else if (level === 1)
            {
                lvl0 = selectedIndex[0];
                lvl1 = index;
                if (lvl1 >= 0)
                {
                    lvl2 = model[lvl0]["sublevel"][lvl1]["subindex"];
                }
            }
            else if (level === 2)
            {
                lvl0 = selectedIndex[0];
                lvl1 = selectedIndex[1];
                lvl2 = index;
            }
            else
            {
                console.log("Menu Unknow level " + level);
            }

            selectedIndex = [lvl0, lvl1, lvl2];
        }
    }
} 
