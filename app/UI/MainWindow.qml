import QtQuick 2.7
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
        target: regovar
        onProjectsOpenChanged:
        {
            console.log ("ReloadMenu (projects)");
            Regovar.reloadProjectsOpenEntries();
            buildPages(menuModel.model[2]["sublevel"], Regovar.currentopeningProject);
            // select currentEntry
            Regovar.menuModel.selectedIndex=[2, regovar.projectsOpen.length,0];
        }
    }
    Connections
    {
        target: regovar
        onSubjectsOpenChanged:
        {
            console.log ("ReloadMenu (subjects)");
            Regovar.reloadSubjectsOpenEntries();
            buildPages(menuModel.model[3]["sublevel"], Regovar.currentopeningSubject);
            // select currentEntry
            Regovar.menuModel.selectedIndex=[3, regovar.subjectsOpen.length,0];
        }
    }

    Connections
    {
        target: regovar
        onWebsocketMessageReceived:
        {
            //console.log ("WS [" + action + "] " + data);
        }
    }


}
