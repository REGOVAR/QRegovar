import QtQuick 2.7

import "../Regovar"

Rectangle
{
    id: root
    width: 200
    height: header.height + sublevelList.height
    state: indexToState()

    property alias icon: icon.text
    property alias label: label.text
    property string currentState: indexToState()
    property int selectedIndex: -1
    property int sublevelListMaxHeight
    property MenuModel model


    function indexToState()
    {
        return (root.selectedIndex !== index) ? "normal" : ((sublevelModel.count > 0) ? "expanded" : "selected");
    }



    Component.onCompleted:
    {
        // Get sublevel if exists
        var lvl0 = model.selectedIndex[0];
        var lvl1 = model.selectedIndex[1];
        var lvl2 = model.selectedIndex[2];
        sublevelModel.append(model.model[lvl0].sublevel[lvl1].sublevel)
        root.sublevelListMaxHeight = sublevelModel.count * 30 // see MenuEntryL3.height
        sublevelList.height = 0
        root.selectedIndex = lvl1;
    }

    // Update view states only from main model update to avoid binding loop
    // and inconsistency between views and model
    Connections
    {
        target: model
        onSelectedIndexChanged:
        {
            if (root.selectedIndex !== model.selectedIndex[1])
            {
                // When main model change, notify views that index have changed
                root.selectedIndex = model.selectedIndex[1];
                // Force update of the state
                root.currentState = indexToState();
                root.state = root.currentState;
            }
        }
    }



    FontLoader { id: iconsFont; source: "../Icons.ttf" }

    ListModel { id: sublevelModel }


    Row
    {
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        id: header
        height: 40

        Text
        {
            id: icon
            width: 50
            height: header.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: iconsFont.name
            font.pixelSize: Regovar.theme.font.size.header
        }
        Text
        {
            id: label
            height: header.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.header
        }
    }
    Text
    {
        id: subLevelIndicator
        anchors.right: header.right
        anchors.top: header.top
        anchors.bottom: header.bottom
        width: 50
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: iconsFont.name
        font.pixelSize: Regovar.theme.font.size.header
        text: "{"
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: header
        hoverEnabled: true
        onEntered:
        {
            root.state = "hover"
        }
        onExited:
        {
            root.state = parent.currentState

        }
        onClicked:
        {
            // Notify model that entry {index} of the level 1 is selected
            model.select(1, index);
        }
    }

    Column
    {
        id: sublevelList
        anchors.top: header.bottom
        anchors.left: header.left
        anchors.right: header.right

        clip: true

        Repeater
        {
            model: sublevelModel

            MenuEntryL3
            {
                model: model
                label: sublevelModel.get(index).label
            }
        }
    }







    states:
    [
        State
        {
            name: "normal"
            PropertyChanges { target: root; color: Regovar.theme.primaryColor.back.normal}
            PropertyChanges { target: icon; color: Regovar.theme.secondaryColor.back.light}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: subLevelIndicator; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: subLevelIndicator; rotation: 0}
            PropertyChanges { target: mouseArea; enabled: true}
            PropertyChanges { target: sublevelList; height: 0}
        },
        State
        {
            name: "hover"
            PropertyChanges { target: root; color: Regovar.theme.secondaryColor.back.normal}
            PropertyChanges { target: icon; color: Regovar.theme.secondaryColor.front.normal}
            PropertyChanges { target: label; color: Regovar.theme.secondaryColor.front.normal}
            PropertyChanges { target: subLevelIndicator; color: Regovar.theme.secondaryColor.front.normal}
        },
        State
        {
            name: "selected"
            PropertyChanges { target: root; color: Regovar.theme.primaryColor.back.light}
            PropertyChanges { target: icon; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: subLevelIndicator; color: Regovar.theme.primaryColor.front.normal}
        },
        State
        {
            name: "expanded"
            PropertyChanges { target: root; color: Regovar.theme.primaryColor.back.light}
            PropertyChanges { target: icon; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.dark}
            PropertyChanges { target: subLevelIndicator; color: Regovar.theme.primaryColor.back.dark}
            PropertyChanges { target: subLevelIndicator; rotation: 90}
            PropertyChanges { target: sublevelList; height: sublevelListMaxHeight}
            PropertyChanges { target: mouseArea; enabled: false}
        }
    ]


    transitions:
    [
        Transition
        {
            from: "normal"
            to: "selected"
            ColorAnimation { duration: 500 }
        },
        Transition
        {
            from: "selected"
            to: "normal"
            ColorAnimation { duration: 200 }
        },
        Transition
        {
            from: "normal"
            to: "expanded"
            NumberAnimation { target: subLevelIndicator; property: "rotation"; duration: 200; easing.type: Easing.InOutQuad }
            NumberAnimation { target: sublevelList; property: "height"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition
        {
            from: "expanded"
            to: "normal"
            NumberAnimation { target: subLevelIndicator; property: "rotation"; duration: 200; easing.type: Easing.InOutQuad }
            NumberAnimation { target: sublevelList; property: "height"; duration: 200; easing.type: Easing.InOutQuad }
        }
    ]
}
