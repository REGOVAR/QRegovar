import QtQuick 2.7
import QtQuick.Controls 2.2
import "../Regovar"

Item
{
    id: mainMenu
    state: "level0"

    property var previousIndex: [0, -1,-1]


    property bool subLevelPanelDisplayed: false
    onSubLevelPanelDisplayedChanged: mainMenu.state = mainMenu.subLevelPanelDisplayed ? "level1" : "level0"
    Binding
    {
        target: Regovar.mainMenu
        property: "subLevelPanelDisplayed"
        value: mainMenu.subLevelPanelDisplayed
    }
    Binding
    {
        target: mainMenu
        property: "subLevelPanelDisplayed"
        value: Regovar.mainMenu.subLevelPanelDisplayed
    }




    Connections
    {
        target: Regovar.mainMenu
        onSelectedIndexChanged:
        {
            var lvl0 = Regovar.mainMenu.selectedIndex[0];
            var lvl1 = Regovar.mainMenu.selectedIndex[1];
            // Check if need to open menu sub level
            if (Regovar.mainMenu.model[lvl0]["page"] === "")
            {
                // Open sublevel and select subentry
                if (lvl1 >= 0)
                {
                    openLevel2();
                }
                else
                {
                    closeLevel2();
                }
            }
            else if (Regovar.mainMenu.model[lvl0]["page"] === "@close")
            {
                regovar.close();
            }
            else
            {
                closeLevel2();
            }

            previousIndex = Regovar.mainMenu.selectedIndex;
        }
    }




    // Display and update submenu for project when project selected
    Connections
    {
        target: regovar
        onCurrentProjectChanged:
        {
            Regovar.mainMenu.selectedIndex = 1 // force selection of the Project section
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
        var lvl0 = Regovar.mainMenu.selectedIndex[0];
        var lvl1 = Regovar.mainMenu.selectedIndex[1];

        if (lvl1 >= 0 && previousIndex[1] !== lvl1)
        {
            Regovar.mainMenu.subLevelPanelDisplayed = true;
            Regovar.mainMenu._subLevelPanelDisplayed = true;
            subMenuModel.clear();
            subMenuModel.append(Regovar.mainMenu.model[lvl0].sublevel);
            return true;
        }
        return false;
    }
    function closeLevel2()
    {
        Regovar.mainMenu.subLevelPanelDisplayed = false
        Regovar.mainMenu._subLevelPanelDisplayed = false
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
            PropertyChanges { target: mainMenu; subLevelPanelDisplayed: false}
        },
        State
        {
            name: "level1"
            PropertyChanges { target: mainMenu; width: 250}
            PropertyChanges { target: subLevel; width: 200}
            PropertyChanges { target: mainMenu; subLevelPanelDisplayed: true}
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
