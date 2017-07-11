import QtQuick 2.7
import "../Regovar"


//Text
//{
//    text: subMenuModel.get(index).label
//    height: header.height
//    verticalAlignment: Text.AlignVCenter
//    font.pixelSize: Regovar.theme.font.size.control
//}

Rectangle
{
    id: root
    height: 30
    width: parent.width
    state: "normal"


    property alias label: label.text
    property string currentState: "normal"
    property int selectedIndex: 0

    onSelectedIndexChanged: root.currentState = (root.selectedIndex !== index) ? "normal" : "selected"
    onCurrentStateChanged: root.state = root.currentState

    // bidirectional binding of selectedEntry between view and main model
    Binding
    {
        target: Regovar.mainMenu
        property: "selectedSubSubIndex"
        value: root.selectedIndex
    }
    Binding
    {
        target: root
        property: "selectedIndex"
        value: Regovar.mainMenu.selectedSubSubIndex
    }


    Text
    {
        id: label
        anchors.fill: root
        anchors.leftMargin: 50
        text: subMenuModel.get(index).label
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.control
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
        onClicked: root.selectedIndex = index
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
