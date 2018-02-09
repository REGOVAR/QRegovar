import QtQuick 2.9
import org.regovar 1.0

import "../Regovar"

Rectangle
{
    id: root
    height: 50

    property alias icon: icon.text
    property alias label: label.text
    property bool selected
    onSelectedChanged: setState()

    property RootMenu menuModel
    property MenuEntry model
    onModelChanged:
    {
        if (model)
        {
            selected = Qt.binding(function() { return model.selected; });
            setState();
        }
    }

    function setState()
    {
        state = selected ? "selected" : "normal";
    }


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
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.title
        }
        Text
        {
            id: label
            height: root.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.title
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
            root.state = "hover";
            menuModel.hiddeSubLevelPanel();
        }
        onExited:
        {
            setState();
            menuModel.restoreSubLevelPanel();
        }
        onClicked: menuModel.select(0, index)
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
