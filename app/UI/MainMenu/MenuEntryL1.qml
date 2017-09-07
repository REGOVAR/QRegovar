import QtQuick 2.7

import "../Regovar"

Rectangle
{
    id: root
    width: 250
    height: 50
    state: indexToState()

    property alias icon: icon.text
    property alias label: label.text
    property string currentState: indexToState()
    property int selectedIndex: -1
    property MenuModel model


    function indexToState()
    {
        return (root.selectedIndex !== index) ? "normal" : "selected"
    }


    // Update view states only from main model update to avoid binding loop
    // and inconsistency between views and model
    Connections
    {
        target: model
        onSelectedIndexChanged:
        {
            if (root.selectedIndex !== model.selectedIndex[0])
            {
                // When main model change, notify views that index have changed
                root.selectedIndex = model.selectedIndex[0];
                // Force update of the state
                root.currentState = indexToState();
                root.state = root.currentState;
            }
        }
    }


    FontLoader { id: iconsFont; source: "../Icons.ttf" }



    Row
    {
        anchors.fill: root
        spacing: 15

        Text
        {
            id: icon
            width: 50
            height: root.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: iconsFont.name
            font.pixelSize: 22
        }
        Text
        {
            id: label
            height: root.height
            verticalAlignment: Text.AlignVCenter
            //font.bold: true
            font.pixelSize: 22
        }
    }

    Rectangle
    {
        id: selectHighlight
        width: 6
        height: root.height
        anchors.left: root.left
        color: Regovar.theme.secondaryColor.back.normal
    }


    MouseArea {
        id: mouseArea
        anchors.fill: root
        hoverEnabled: true
        onEntered:
        {
            root.state = "hover"
            model.subLevelPanelDisplayed = false
        }
        onExited:
        {
            root.state = parent.currentState
            model.subLevelPanelDisplayed = model._subLevelPanelDisplayed

        }
        onClicked:
        {
            // Notify model that entry {index} of the level 0 is selected
            model.select(0, index);
        }
    }

    states: [
        State
        {
            name: "normal"
            PropertyChanges { target: root; color: Regovar.theme.primaryColor.back.dark}
            PropertyChanges { target: icon; color: Regovar.theme.primaryColor.back.light}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.light}
            PropertyChanges { target: selectHighlight; visible: false}
        },
        State
        {
            name: "hover"
            PropertyChanges { target: root; color: Regovar.theme.secondaryColor.back.normal}
            PropertyChanges { target: icon; color: Regovar.theme.secondaryColor.front.normal}
            PropertyChanges { target: label; color: Regovar.theme.secondaryColor.front.normal}
        },
        State
        {
            name: "selected"
            PropertyChanges { target: root; color: Regovar.theme.primaryColor.back.normal}
            PropertyChanges { target: icon; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.front.normal}
            PropertyChanges { target: selectHighlight; visible: true}

        }
    ]


    transitions:
    [
        Transition {
            from: "normal"
            to: "selected"
            ColorAnimation { duration: 500 }
        },
        Transition {
            from: "selected"
            to: "normal"
            ColorAnimation { duration: 200 }
        }
    ]
}
