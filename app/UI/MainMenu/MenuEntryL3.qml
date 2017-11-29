import QtQuick 2.9

import "../Regovar"


//Text
//{
//    text: subMenuModel.get(index).label
//    height: header.height
//    verticalAlignment: Text.AlignVCenter
//    font.pixelSize: Regovar.theme.font.size.normal
//}

Rectangle
{
    id: root
    height: 30
    width: parent.width
    state: indexToState()


    property alias label: label.text
    property string currentState: indexToState()
    property int selectedIndex: -1
    property MenuModel model


    function indexToState()
    {
        return (root.selectedIndex !== index) ? "normal" : "selected";
    }


    onModelChanged:
    {
        root.selectedIndex = model.selectedIndex[2];
    }


    // Update view states only from main model update to avoid binding loop
    // and inconsistency between views and model
    Connections
    {
        target: model
        onSelectedIndexChanged:
        {
            // When main model change, notify views that index have changed
            root.selectedIndex = model.selectedIndex[2];
            // Force update of the state
            root.currentState = indexToState();
            root.state = root.currentState;
        }
    }


    Text
    {
        id: label
        anchors.fill: root
        anchors.leftMargin: 50
        text: subMenuModel.get(index).label
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.normal
    }
    MouseArea
    {
        anchors.fill: root
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
            model.select(2, index);
        }
    }

    states:
    [
        State
        {
            name: "normal"
            PropertyChanges { target: root; color: "transparent"}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.normal}
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
