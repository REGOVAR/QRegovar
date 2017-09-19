import QtQuick 2.7
import QtQuick.Controls 2.2

import "../Regovar"

Item
{
    id: mainMenu
    state: "level0"

    property MenuModel model

    property var previousIndex: [0, -1,-1]
    property var selectedIndex
    property bool collapsable: false
    clip: true


    property bool subLevelPanelDisplayed: false
    onSubLevelPanelDisplayedChanged: mainMenu.state = mainMenu.subLevelPanelDisplayed ? "level1" : "level0"


    onModelChanged:
    {
        if (model !== undefined)
        {
            // Properties binding with the model... not working :(
//            mainMenu.subLevelPanelDisplayed = Qt.binding(function()
//            {
//                return model.subLevelPanelDisplayed;
//            });
//            mainMenu.selectedIndex = Qt.binding(function()
//            {
//                return model.selectedIndex;
//            });

            // signals connections with the model
            model.onSelectedIndexChanged.connect(function()
            {
                mainMenu.selectedIndex = model.selectedIndex;
            });
            model.onSubLevelPanelDisplayedChanged.connect(function()
            {
                mainMenu.subLevelPanelDisplayed = model.subLevelPanelDisplayed;
            });

            menuModel.append(model.model);
        }
    }

    onSelectedIndexChanged:
    {
        var lvl0 = model.selectedIndex[0];
        var lvl1 = model.selectedIndex[1];
        // Check if need to open menu sub level
        if (model.model[lvl0]["page"] === "")
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
        else if (model.model[lvl0]["page"] === "@close")
        {
            regovar.close();
        }
        else
        {
            closeLevel2();
        }

        previousIndex = model.selectedIndex;
    }



    Behavior on width
    {
        NumberAnimation
        {
            easing: Easing.OutQuad
            duration : 150
        }
    }




    // --------------------------------------------------
    // View internals models
    // --------------------------------------------------
    ListModel
    {
        id: menuModel
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
        var lvl0 = model.selectedIndex[0];
        var lvl1 = model.selectedIndex[1];
        var lvl2 = model.selectedIndex[2];



        if (lvl0 !== previousIndex[0] || lvl1 !== previousIndex[1])
        {
            model.subLevelPanelDisplayed = true;
            model._subLevelPanelDisplayed = true;
            subMenuModel.clear();
            subMenuModel.append(model.model[lvl0].sublevel);

        }
        return true;
    }
    function closeLevel2()
    {

        model.subLevelPanelDisplayed = false
        model._subLevelPanelDisplayed = false
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
                model: mainMenu.model
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
                    text : model.mainTitle
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
                    model: mainMenu.model
                    icon:  (subMenuModel.get(index) !== undefined) ? subMenuModel.get(index).icon : ""
                    label: (subMenuModel.get(index) !== undefined) ? subMenuModel.get(index).label : ""
                }
            }
        }
    }

    Rectangle
    {
        visible: mainMenu.collapsable
        anchors.bottom: mainMenu.bottom
        anchors.left: mainMenu.left
        width: 50
        height: 50
        color: "transparent"
        z: 1000

        Text
        {
            id: collapseIcon
            anchors.fill: parent
            text: "t"
            font.pixelSize: Regovar.theme.font.size.title
            font.family: Regovar.theme.icons.name
            color: Regovar.theme.primaryColor.back.light
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        MouseArea
        {
            enabled: mainMenu.collapsable
            anchors.fill: parent
            hoverEnabled: true
            onEntered: collapseIcon.color = Regovar.theme.secondaryColor.back.normal
            onExited: collapseIcon.color = Regovar.theme.primaryColor.back.light
            onClicked:
            {
                if (mainMenu.width == 250)
                {
                    mainMenu.width = 50;
                    collapseIcon.text = "s";
                    subLevel.visible = false;
                }
                else
                {
                    mainMenu.width = 250;
                    collapseIcon.text = "t";
                    subLevel.visible = true;
                }

            }
        }

        Behavior on color
        {
            ColorAnimation
            {
               duration : 200
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
