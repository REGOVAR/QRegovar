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
        property int selectedSubIndex: -1
        property int selectedSubSubIndex: -1

        property bool collapseMenu: false

        property bool displaySubLevel: false
        property bool displaySubLevelCurrent: false // to store current state when need to quickly/temporarly switch the level2 display on mousehover
        
        
        property var model:  [
            { "icon": "a", "label": "Welcome",      "page": "WelcomPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "c", "label": "Project",      "page": "ProjectPage.qml", "sublevel": [
                { "icon": "j", "label": "Resume",   "page": "Project/ResumePage.qml", "sublevel": [], "subindex": -1},
                { "icon": "H", "label": "Events",   "page": "Project/EventsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "b", "label": "Subjects", "page": "Project/SubjectsPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "I", "label": "Analyses", "page": "Project/AnalysesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "O", "label": "Files",    "page": "Project/FilesPage.qml", "sublevel": [], "subindex": -1},
                { "icon": "d", "label": "Settings", "page": "Project/SettingsInformationsPage.qml", "sublevel": [
                    { "label": "Informations",      "page": "Project/SettingsInformationsPage.qml", "sublevel": []},
                    { "label": "Indicators",        "page": "Project/SettingsIndicatorsPage.qml", "sublevel": []},
                    { "label": "Sharing",           "page": "Project/SettingsSharingPage.qml", "sublevel": []},
                    ], "subindex": 0}
                ], "subindex": -1},
            { "icon": "b", "label": "Subject",      "page": "SubjectPage.qml",    "sublevel": [], "subindex": -1},
            { "icon": "d", "label": "Settings",     "page": "SettingsPage.qml",   "sublevel": [], "subindex": -1},
            { "icon": "e", "label": "Help",         "page": "HelpPage.qml",       "sublevel": [], "subindex": -1},
            { "icon": "f", "label": "About",        "page": "AboutPage.qml",      "sublevel": [], "subindex": -1},
            { "icon": "g", "label": "Disconnect",   "page": "DisconnectPage.qml", "sublevel": [], "subindex": -1},
            { "icon": "h", "label": "Close",        "page": "ClosePage.qml",      "sublevel": [], "subindex": -1}
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


    property var currentProject
    property var currentSubject


    onCurrentProjectChanged:
    {

    }

    property QtObject settings: QtObject
    {
        property QtObject server: QtObject
        {

            property string host: "http://dev.regovar.org"
        }
    }
} 
