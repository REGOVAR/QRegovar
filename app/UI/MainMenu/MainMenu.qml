import QtQuick 2.7
import "../Regovar"

Item
{
    id: mainMenu
    state: "level0"



    property bool displaySubLevel: false
    onDisplaySubLevelChanged: mainMenu.state = mainMenu.displaySubLevel ? "level1" : "level0"
    Binding
    {
        target: Regovar.mainMenu
        property: "displaySubLevel"
        value: mainMenu.displaySubLevel
    }
    Binding
    {
        target: mainMenu
        property: "displaySubLevel"
        value: Regovar.mainMenu.displaySubLevel
    }


    // bidirectional binding of selectedEntry between view and main model
    property int selectedIndex: 0
    Binding
    {
        target: Regovar.mainMenu
        property: "selectedMainIndex"
        value: mainMenu.selectedIndex
    }
    Binding
    {
        target: mainMenu
        property: "selectedIndex"
        value: Regovar.mainMenu.selectedMainIndex
    }

    // --------------------------------------------------
    // View internals models
    // --------------------------------------------------
    ListModel
    {
        id: menuModel
        Component.onCompleted: { menuModel.append(Regovar.mainMenu.model)}
    }

    ListModel
    {
        id: subMenuModel
    }



    // --------------------------------------------------
    // The view (root level)
    // --------------------------------------------------
    Rectangle
    {
        id: back
        color: Regovar.theme.primaryColor.back.dark
        anchors.fill: mainMenu
        z: 0
    }
    Column
    {
        Repeater
        {
            model: menuModel

            MenuEntryL1
            {
                id: menuItem
                icon: menuModel.get(index).icon
                label: menuModel.get(index).label

                // Bidirectional binding between selectedIndex properties of the MainMenu and its items
                Binding {
                    target: menuItem
                    property: "selectedIndex"
                    value: mainMenu.selectedIndex
                }
                Binding {
                    target: mainMenu
                    property: "selectedIndex"
                    value: menuItem.selectedIndex
                }
            }
        }
    }

    // --------------------------------------------------
    // The view (level 2)
    // --------------------------------------------------
    Rectangle
    {
        id: subLevel
        color: Regovar.theme.primaryColor.back.normal
        anchors.top: mainMenu.top
        anchors.bottom: mainMenu.bottom
        anchors.right: mainMenu.right
        width: 0
        clip: true
        z: 10

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
        }


        Column
        {
            anchors.fill: subLevel
            Row
            {
                FontLoader { id: iconsFont; source: "../Icons.ttf" }

                Text
                {
                    id: icon
                    width: 50
                    height: 49
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: iconsFont.name
                    font.pixelSize: 22
                    text: "t"
                    color: Regovar.theme.primaryColor.back.dark
                }
                Text
                {
                    id: label
                    height: 49
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 22
                    text : Regovar.mainMenu.mainTitle
                    color: Regovar.theme.primaryColor.back.dark
                }
            }

            Rectangle
            {
                height:1
                width: subLevel.width
                color: Regovar.theme.primaryColor.back.dark
            }

    //        Repeater
    //        {
    //            model: subMenuModel

    //            MenuEntryL2
    //            {
    //                id: menuItem
    //                icon: menuModel.get(index).icon
    //                label: menuModel.get(index).label

    //                // Bidirectional binding between selectedIndex properties of the MainMenu and its items
    //                Binding {
    //                    target: menuItem
    //                    property: "selectedIndex"
    //                    value: mainMenu.selectedIndex
    //                }
    //                Binding {
    //                    target: mainMenu
    //                    property: "selectedIndex"
    //                    value: menuItem.selectedIndex
    //                }
    //            }
    //        }
        }
    }



    states: [
        State
        {
            name: "level0"
            PropertyChanges { target: mainMenu; width: 300}
            PropertyChanges { target: subLevel; width: 0}
            PropertyChanges { target: mainMenu; displaySubLevel: false}
        },
        State
        {
            name: "level1"
            PropertyChanges { target: mainMenu; width: 300}
            PropertyChanges { target: subLevel; width: 250}
            PropertyChanges { target: mainMenu; displaySubLevel: true}
        },
        State
        {
            name: "minified"
            PropertyChanges { target: mainMenu; width: 0}
            PropertyChanges { target: subLevel; width: 0}
        }
    ]


    transitions:
    [
        Transition
        {
            from: "level0"
            to: "level1"
            NumberAnimation
            {
                target: subLevel
                property: "width"
                duration: 250
                easing.type: Easing.OutQuad
            }
        },
        Transition
        {
            from: "level1"
            to: "level0"
            NumberAnimation
            {
                target: subLevel
                property: "width"
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
    ]
}
