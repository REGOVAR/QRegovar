import QtQuick 2.7
import "../Regovar"

Rectangle
{
    id: root
    width: 200
    height: header.height + sublevelList.height
    state: "normal"

    property alias icon: icon.text
    property alias label: label.text
    property string currentState: "normal"
    property int selectedIndex: 0
    property int sublevelListMaxHeight

    onSelectedIndexChanged: root.currentState = (root.selectedIndex !== index) ? "normal" : ((sublevelModel.count > 0) ? "expanded" : "selected")
    onCurrentStateChanged: root.state = root.currentState



    Component.onCompleted:
    {
        // Get sublevel if exists
        sublevelModel.append(Regovar.mainMenu.model[Regovar.mainMenu.selectedMainIndex].sublevel[index].sublevel)
        root.sublevelListMaxHeight = sublevelModel.count * 30 // see MenuEntryL3.height
        sublevelList.height = 0
    }

    // bidirectional binding of selectedEntry between view and main model
    Binding
    {
        target: Regovar.mainMenu
        property: "selectedSubIndex"
        value: root.selectedIndex
    }
    Binding
    {
        target: root
        property: "selectedIndex"
        value: Regovar.mainMenu.selectedSubIndex
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
            root.selectedIndex = index
            Regovar.mainMenu.selectedSubSubIndex= 0
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
