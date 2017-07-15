import QtQuick 2.7
import QtQuick.Controls 2.2
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





    // Open/Close level 2 according to the selection changed in the mainMenu at the 1st level
    Connections
    {
        target: Regovar.mainMenu
        onSelectedSubIndexChanged:
        {
            if (Regovar.mainMenu.selectedSubIndex < 0)
            {
                closeLevel2();
            }
        }
    }
    // Display and update submenu for project when project selected
    Connections
    {
        target: Regovar
        onCurrentProjectChanged:
        {
            Regovar.mainMenu.selectedMainIndex = 1 // force selection of the Project section
            openLevel2();

        }
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
    // Methods
    // --------------------------------------------------
    function openLevel2()
    {
        if (Regovar.mainMenu.selectedMainIndex >= 0 && Regovar.mainMenu.selectedMainIndex < Regovar.mainMenu.model.length)
        {
            Regovar.mainMenu.displaySubLevel = true;
            Regovar.mainMenu.displaySubLevelCurrent = true;
            subMenuModel.clear();
            subMenuModel.append(Regovar.mainMenu.model[Regovar.mainMenu.selectedMainIndex]["sublevel"]);
            return true;
        }
        return false;
    }
    function closeLevel2()
    {
        Regovar.mainMenu.displaySubLevel = false
        Regovar.mainMenu.displaySubLevelCurrent = false
        subMenuModel.clear()
        return true;
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
                id: menuL2Header
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
                    text: "]"
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

            Repeater
            {
                model: subMenuModel

                MenuEntryL2
                {
                    id: menu2Item
                    icon: subMenuModel.get(index).icon
                    label: subMenuModel.get(index).label
                }
            }
        }
    }



    states: [
        State
        {
            name: "level0"
            PropertyChanges { target: mainMenu; width: 250}
            PropertyChanges { target: subLevel; width: 0}
            PropertyChanges { target: mainMenu; displaySubLevel: false}
        },
        State
        {
            name: "level1"
            PropertyChanges { target: mainMenu; width: 250}
            PropertyChanges { target: subLevel; width: 200}
            PropertyChanges { target: mainMenu; displaySubLevel: true}
        },
        State
        {
            name: "minified"
            PropertyChanges { target: mainMenu; width: 50}
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
