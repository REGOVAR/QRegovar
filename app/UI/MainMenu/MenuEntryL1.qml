import QtQuick 2.7
import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{

    id: parent

    property alias icon: icon.text
    property alias label: label.text
    property string currentState: "normal"
    property string selectedEntry: ""

    onSelectedEntryChanged: parent.currentState = (parent.selectedEntry !== label.text) ? "normal" : "selected"
    onCurrentStateChanged: parent.state = parent.currentState


    width: 300
    height: 50
    state: "normal"

    FontLoader { id: iconsFont; source: "../Icons.ttf" }


    Row
    {
        anchors.fill: parent
        spacing: 15

        Text
        {
            id: icon
            width: 50
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: iconsFont.name
            font.pixelSize: 22
        }
        Text
        {
            id: label
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            //font.bold: true
            font.pixelSize: 22
        }
    }

    Rectangle
    {
        id: selectHighlight
        width: 6
        height: parent.height
        anchors.left: parent.left
        color: ColorTheme.secondaryBackColor
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.state = "hover"
        onExited: parent.state = parent.currentState
        onClicked: parent.selectedEntry = label.text
    }







    states: [
        State
        {
            name: "normal"
            PropertyChanges { target: parent; color: ColorTheme.primaryDarkBackColor}
            PropertyChanges { target: icon; color: ColorTheme.primaryBackColor}
            PropertyChanges { target: label; color: ColorTheme.primaryBackColor}
            PropertyChanges { target: selectHighlight; visible: false}
        },
        State
        {
            name: "hover"
            PropertyChanges { target: parent; color: ColorTheme.secondaryBackColor}
            PropertyChanges { target: icon; color: ColorTheme.secondaryFrontColor}
            PropertyChanges { target: label; color: ColorTheme.secondaryFrontColor}
        },
        State
        {
            name: "selected"
            PropertyChanges { target: parent; color: ColorTheme.primaryBackColor}
            PropertyChanges { target: icon; color: ColorTheme.primaryFrontColor}
            PropertyChanges { target: label; color: ColorTheme.primaryFrontColor}
            PropertyChanges { target: selectHighlight; visible: true}

        }
    ]


    transitions: [
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
