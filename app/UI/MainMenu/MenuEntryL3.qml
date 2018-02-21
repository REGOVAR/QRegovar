import QtQuick 2.9
import Regovar.Core 1.0

import "../Regovar"


Rectangle
{
    id: root
    height: 30
    width: parent.width

//    property alias icon: icon.text
    property alias label: label.text
    property int sublevelListMaxHeight
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


    Text
    {
        id: label
        anchors.fill: root
        anchors.leftMargin: 50
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.normal
    }
    MouseArea
    {
        anchors.fill: root
        hoverEnabled: true
        onEntered: root.state = "hover"
        onExited: setState()
        onClicked: menuModel.select(2, index)
    }

    states:
    [
        State
        {
            name: "normal"
            PropertyChanges { target: root; color: "transparent"}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.dark}
        },
        State
        {
            name: "hover"
            PropertyChanges { target: root; color: Regovar.theme.secondaryColor.back.normal}
            PropertyChanges { target: label; color: Regovar.theme.secondaryColor.front.normal}
        },
        State
        {
            name: "selected"
            PropertyChanges { target: root; color: "transparent"}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.front.normal}
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
