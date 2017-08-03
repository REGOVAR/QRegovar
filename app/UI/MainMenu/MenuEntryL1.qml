import QtQuick 2.7
import "../Regovar"

Rectangle
{
    id: root
    width: 250
    height: 50
    state: "normal"

    property alias icon: icon.text
    property alias label: label.text
    property string currentState: "normal"
    property int selectedIndex: 0
    onSelectedIndexChanged: root.currentState = (root.selectedIndex !== index) ? "normal" : "selected"
    onCurrentStateChanged: root.state = root.currentState


    // bidirectional binding of selectedEntry between view and main model
    Binding
    {
        target: Regovar.mainMenu
        property: "selectedMainIndex"
        value: root.selectedIndex
    }
    Binding
    {
        target: root
        property: "selectedIndex"
        value: Regovar.mainMenu.selectedMainIndex
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
            Regovar.mainMenu.displaySubLevel = false
        }
        onExited:
        {
            root.state = parent.currentState
            Regovar.mainMenu.displaySubLevel = Regovar.mainMenu.displaySubLevelCurrent

        }
        onClicked:
        {
            root.selectedIndex = index
            if (Regovar.mainMenu.model[index]["page"] == "")
            {
                openLevel2();
            }

        }
    }







    states: [
        State
        {
            name: "normal"
            PropertyChanges { target: root; color: Regovar.theme.primaryColor.back.dark}
            PropertyChanges { target: icon; color: Regovar.theme.primaryColor.back.normal}
            PropertyChanges { target: label; color: Regovar.theme.primaryColor.back.normal}
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
