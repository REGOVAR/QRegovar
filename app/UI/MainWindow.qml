import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import "Framework"
import "MainMenu"
import "Pages"
import "Regovar"
import "Dialogs"

ApplicationWindow
{
    id: root
    visible: true
    title: "Regovar - " + Regovar.mainMenu.mainTitle
    width: 800
    height: 600



    Settings
    {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }

    // Load root's pages of regovar
    property var menuPageMapping: ({})
    function buildPages(model, baseIndex)
    {
        for (var idx in model)
        {
            if (model[idx]["page"] != "" && model[idx]["page"][0] != "@")
            {
                var comp = Qt.createComponent("Pages/" + model[idx]["page"]);
                root.menuPageMapping[baseIndex+idx] = comp;
                console.log ("load " + baseIndex+idx + " : Pages/" + model[idx]["page"])
            }
            else
            {
                root.menuPageMapping[baseIndex+idx] = false;
            }

            if (model[idx]["sublevel"].length > 0)
            {
                buildPages(model[idx]["sublevel"], baseIndex+idx + "-")
            }

        }
    }


    Component.onCompleted:
    {
        buildPages(Regovar.mainMenu.model, "")
        stack.sourceComponent = menuPageMapping[0]
    }



    Connections
    {
        target: Regovar.mainMenu
        onSelectedMainIndexChanged:
        {
            if (menuPageMapping)
            {
                // if there is a page for this entry
                stack.sourceComponent = menuPageMapping[Regovar.mainMenu.selectedMainIndex];
            }
            else
            {
                // otherwise, need to load first page of second level
                Regovar.mainMenu.selectedSubIndex = menuPageMapping[Regovar.mainMenu.selectedMainIndex]["subindex"];
                stack.sourceComponent = menuPageMapping[Regovar.mainMenu.selectedMainIndex + "-" +Regovar.mainMenu.selectedSubIndex]
            }
        }
    }
    Connections
    {
        target: Regovar.mainMenu
        onSelectedSubIndexChanged:
        {
            console.log ("open " + Regovar.mainMenu.selectedMainIndex + "-" +Regovar.mainMenu.selectedSubIndex)
            stack.sourceComponent = menuPageMapping[Regovar.mainMenu.selectedMainIndex + "-" +Regovar.mainMenu.selectedSubIndex]
        }
    }
    Connections
    {
        target: regovar
        onCurrentProjectUpdated:
        {
            Regovar.mainMenu.selectedSubIndex = 0;
            stack.sourceComponent = menuPageMapping[Regovar.mainMenu.selectedMainIndex + "-" +Regovar.mainMenu.selectedSubIndex]
        }
    }

    Connections
    {
        target: regovar
        onClose:
        {
            closePopup.open()
        }
    }
    Connections
    {
        target: regovar
        onError:
        {
            errorPopup.open()
        }
    }



    MainMenu
    {
        id: mainMenu
        z: 10
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 300
    }

    Loader
    {
        id: stack
        z:0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: mainMenu.right
        anchors.right: parent.right

        onSourceComponentChanged:
        {
            anim.start()
        }

        NumberAnimation
        {
            id: anim
            target: stack
            property: "opacity"
            easing.type: Easing.OutQuad
            from: 0
            to: 1
            duration: 250
        }
    }

    CloseDialog
    {
        id: closePopup
        visible: false
    }
    ErrorDialog
    {
        id: errorPopup
        visible: false
    }

}
