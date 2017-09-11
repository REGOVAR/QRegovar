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
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }


    Connections
    {
        target: regovar
        onProjectsOpenChanged:
        {
            console.log ("ReloadMenu");
            Regovar.reloadProjectsOpenEntries();
            buildPages(menuModel.model[2]["sublevel"]);
            // select currentEntry
            Regovar.menuModel.selectedIndex=[2, regovar.projectsOpen.length,0];
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
