import QtQuick 2.7
import "../Regovar"


Rectangle
{
    id: root
    width: 50
    height: 50
    border.width: 1
    border.color: Regovar.theme.boxColor.border
    state: "normal"

    property string iconText
    property string currentState: "normal"
    property bool isSelected: false

    onCurrentStateChanged: root.state = root.currentState
    onIsSelectedChanged: root.currentState = (root.isSelected) ? "selected" : "normal"

    FontLoader
    {
        id : iconFont
        source: "../Icons.ttf"
    }



    Text
    {
        id: label
        anchors.centerIn: root
        text: root.iconText
        font.pixelSize: 22
        font.family: iconFont.name
        color: Regovar.theme.primaryColor.back.light
    }

    MouseArea
    {
        anchors.fill: root
        hoverEnabled: true
        onEntered: root.state = "hover";
        onExited: root.state = root.currentState;
        onClicked: root.isSelected = true;
    }

    states:
    [
        State
        {
            name: "normal"
            PropertyChanges { target: root; color: "transparent"}
            PropertyChanges { target: root; border.width: 0}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.light}
        },
        State
        {
            name: "hover"
            PropertyChanges { target: label; color: Regovar.theme.secondaryColor.back.normal}
        },
        State
        {
            name: "selected"
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.dark}
            PropertyChanges { target: root; border.width: 1}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.normal}
        }
    ]

    transitions:
    [
        Transition {
            from: "normal"
            to: "selected"
            ColorAnimation { duration: 200 }
        },
        Transition {
            from: "selected"
            to: "normal"
            ColorAnimation { duration: 200 }
        }
    ]
}
