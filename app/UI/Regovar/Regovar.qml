pragma Singleton
import QtQuick 2.0

import "../Pages"

QtObject 
{
    // TODO onCompleted : reload some value from Settings (like theme used, login/autoconnection, ...)


    property Style theme: Style {}
    

    property QtObject mainMenu: QtObject
    {
        property int selectedMainIndex: 0
        property int selectedSubIndex
        property int selectedSubSubIndex

        property bool collapseMenu: false

        property bool displaySubLevel: false
        property bool displaySubLevelCurrent: false // to store current state when need to quickly/temporarly switch the level2 display on mousehover
        
        
        property var model:  [
            { "icon": "a", "label": "Welcom",       "page": "WelcomPage.qml", "sublevel": []},
            { "icon": "c", "label": "Project",      "page": "ProjectPage.qml", "sublevel": [
                { "icon": "j", "label": "Resume",   "page": "Project/ResumePage.qml", "sublevel": []},
                { "icon": "H", "label": "Events",   "page": "Project/EventsPage.qml", "sublevel": []},
                { "icon": "b", "label": "Subjects", "page": "Project/SubjectsPage.qml", "sublevel": []},
                { "icon": "I", "label": "Analyses", "page": "Project/AnalysesPage.qml", "sublevel": []},
                { "icon": "O", "label": "Files",    "page": "Project/FilesPage.qml", "sublevel": []},
                { "icon": "d", "label": "Settings", "page": "Project/SettingsIndicatorsPage.qml", "sublevel": [
                    { "label": "Informations",      "page": "Project/SettingsInformationsPage.qml", "sublevel": []},
                    { "label": "Indicators",        "page": "Project/SettingsIndicatorsPage.qml", "sublevel": []},
                    { "label": "Sharing",           "page": "Project/SettingsSharingPage.qml", "sublevel": []},
                    ]}
                ]},
            { "icon": "b", "label": "Subject",      "page": "SubjectPage.qml",    "sublevel": []},
            { "icon": "d", "label": "Settings",     "page": "SettingsPage.qml",   "sublevel": []},
            { "icon": "e", "label": "Help",         "page": "HelpPage.qml",       "sublevel": []},
            { "icon": "f", "label": "About",        "page": "AboutPage.qml",      "sublevel": []},
            { "icon": "g", "label": "Disconnect",   "page": "DisconnectPage.qml", "sublevel": []},
            { "icon": "h", "label": "Close",        "page": "ClosePage.qml",      "sublevel": []}
        ]
        
        property string mainTitle: model[selectedMainIndex]["label"]
        onSelectedMainIndexChanged: model[selectedMainIndex]["label"]
        
        function test2()
        {
            console.log("salut olivier2")
        }
    }

    function test()
    {
        console.log("salut olivier")
    }
} 
