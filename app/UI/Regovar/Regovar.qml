pragma Singleton
import QtQuick 2.0

QtObject 
{
    // TODO onCompleted : reload some value from Settings (like theme used, login/autoconnection, ...)


    property Style theme: Style {}
    

    property QtObject mainMenu: QtObject
    {
        property int selectedMainIndex: 0
        property int selectedSubIndex
        property int selectedSubSubIndex
        
        
        property var model:  [
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
