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



    //! Convert MainMenu index into one string key for internal map with qml pages
    function pageIdxKey(idx)
    {
        var key = idx[0];
        if (idx[1] >= 0)  key += "-" + idx[1];
        if (idx[2] >= 0)  key += "-" + idx[2];

        return key;
    }

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


    //! Open qml page according to the selected indexes
    function openPage()
    {
        var idx = Regovar.mainMenu.selectedIndex;
        var mIdx = pageIdxKey(idx);
        console.log ("open " + mIdx);
        stack.sourceComponent = menuPageMapping[mIdx];
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



    Component.onCompleted:
    {
        buildPages(Regovar.mainMenu.model, "");

        stack.sourceComponent = menuPageMapping[pageIdxKey(Regovar.mainMenu.selectedIndex)];
    }



    Connections
    {
        target: Regovar.mainMenu
        onSelectedIndexChanged: openPage();
    }

//    Connections
//    {
//        target: regovar
//        onCurrentProjectUpdated:
//        {
//            Regovar.mainMenu.selectedSubIndex = 0;
//            stack.sourceComponent = menuPageMapping[Regovar.mainMenu.selectedMainIndex + "-" +Regovar.mainMenu.selectedSubIndex]
//        }
//    }

//    Connections
//    {
//        target: regovar
//        onClose:
//        {
//            closePopup.open()
//        }
//    }
//    Connections
//    {
//        target: regovar
//        onError:
//        {
//            errorPopup.open()
//        }
//    }
}
