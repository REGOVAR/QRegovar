import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import "Framework"
import "MainMenu"
import "Pages"
import "Regovar"

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
    property variant menuPageMapping: []
    function buildPages(model, baseIndex)
    {
        for (var idx in model)
        {
            var comp = Qt.createComponent("Pages/" + model[idx]["page"]);
            if (model[idx]["sublevel"].length > 0)
            {
                buildPages(model[idx]["sublevel"], idx + "-")
            }
            root.menuPageMapping[idx] = comp;
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
        onSelectedMainIndexChanged:stack.sourceComponent = menuPageMapping[mainMenu.selectedIndex]
    }
    Connections
    {
        target: Regovar.mainMenu
        onSelectedSubIndexChanged: stack.sourceComponent = menuPageMapping[mainMenu.selectedIndex + "-" + mainMenu.selectedSubIndex]
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
}
