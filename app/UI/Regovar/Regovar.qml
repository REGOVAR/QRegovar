pragma Singleton
import QtQuick 2.0

QtObject 
{
    property Style theme: Style {}
    
    property QtObject mainMenu: QtObject
    {
        property string selectedMainEntry
        property string selectedSubEntry
        property string selectedSubSubEntry
        
        
        property var model: {
            "menu" : [
                { "icon": "a", "label": "Welcom",     "sublevel": []},
                { "icon": "c", "label": "Project",    "sublevel": [
                    { "icon": "j", "label": "Resume",   "sublevel": []},
                    { "icon": "H", "label": "Events",   "sublevel": []},
                    { "icon": "b", "label": "Subjects", "sublevel": []},
                    { "icon": "I", "label": "Analyses", "sublevel": []},
                    { "icon": "O", "label": "Files",    "sublevel": []},
                    { "icon": "d", "label": "Settings", "sublevel": ["Informations", "Indicators", "Sharing"]}
                    ]},
                { "icon": "b", "label": "Subject",    "sublevel": []},
                { "icon": "d", "label": "Settings",   "sublevel": []},
                { "icon": "e", "label": "Help",       "sublevel": []},
                { "icon": "f", "label": "About",      "sublevel": []},
                { "icon": "g", "label": "Disconnect", "sublevel": []},
                { "icon": "h", "label": "Close",      "sublevel": []}
            ]
        }
        
        
    }
} 
