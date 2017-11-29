import QtQuick 2.9
import Qt.labs.settings 1.0

import "Regovar"

GenericWindow
{
    id: root
    width: 800
    height: 600

    property QtObject model


    menuModel: Regovar.menuModel
    title: "Regovar - " + menuModel.mainTitle

    Settings
    {
        id: settings
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height

        property int themeId: 0
        property real fontSizeCoeff: 1.0
    }
    Component.onCompleted:
    {
        Regovar.theme.themeId = settings.themeId
        Regovar.theme.fontSizeCoeff = settings.fontSizeCoeff
    }
    Component.onDestruction:
    {
        // store value choose by the user to restore it next time
        settings.themeId = Regovar.theme.themeId
        settings.fontSizeCoeff = Regovar.theme.fontSizeCoeff
    }


    Connections
    {
        target: regovar.projectsManager
        onProjectsOpenListChanged:
        {
            console.log ("MainMenu: Reload projects open list");
            Regovar.reloadProjectsOpenEntries();
            buildPages(menuModel.model[2]["sublevel"], Regovar.currentopeningProject);
            // select currentEntry
            Regovar.menuModel.selectedIndex=[2, regovar.projectsManager.projectsOpenList.length, 0];
        }
    }

    Connections
    {
        target: regovar.subjectsManager
        onSubjectsOpenListChanged:
        {
            console.log ("RefreshMenu (subjects)");
            // Step 1 : update main menu entries
            var entryModel = Regovar.refreshSubjectsEntries();
            // Step 2 : Build pages for the new entry
            if (entryModel)
            {
                buildPages(menuModel.model[3]["sublevel"], entryModel);
            }
        }
    }
    Connections
    {
        target: regovar.subjectsManager
        onSubjectOpenChanged:
        {
            Regovar.menuModel.selectedIndex=[3, idx+1, 0];
        }
    }




//    Connections
//    {
//        target: regovar.subjectsManager
//        onSubjectCreationDone:
//        {
//            if (success)
//            {
//                console.log ("ReloadMenu (subjects)");
//                // Step 1 : update main menu entries
//                Regovar.refreshSubjectsMenu();
//                // Step 2 : Build page for the entry
//                buildPages(menuModel.model[3]["sublevel"], regovar.subjectsManager.subjectOpen);
//                // Step 3 : Select currentEntry
//                Regovar.menuModel.selectedIndex=[3, 0, 0]; // 0 because new entry always insert at first place in open list
//            }
//        }
//    }

    Connections
    {
        target: regovar.networkManager
        onWebsocketMessageReceived:
        {
            //console.log ("WS [" + action + "] " + data);
        }
    }

    function openSubject(subjectId)
    {
        // ask main model to add subject model into open entries

    }


}
