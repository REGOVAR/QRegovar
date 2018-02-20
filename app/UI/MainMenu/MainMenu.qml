import QtQuick 2.9
import QtQuick.Controls 2.2
import org.regovar 1.0

import "../Regovar"

Item
{
    id: root
    state: "level0"
    clip: true
    width: 250

    signal openPage(var menuEntry)

    property real expandWidth: 250
    property bool subLevelPanelDisplayed: false
    onSubLevelPanelDisplayedChanged: state = subLevelPanelDisplayed ? "level1" : "level0"
    property RootMenu model
    onModelChanged:
    {
        if (model)
        {
            subLevelPanelDisplayed = Qt.binding(function() { return model.subLevelPanelDisplayed;});
            refreshSubEntries();

            model.openPage.connect(onOpenPage);
        }
    }
    Component.onDestruction:
    {
        model.openPage.disconnect(onOpenPage);
    }

    function onOpenPage(menuEntry)
    {
        // force refresh of list. as qml not able to detect change that occure on QList
        refreshSubEntries();
        // open the page
        root.openPage(menuEntry);
    }

    function refreshSubEntries()
    {
        // Refresh the model of the menu repeater
        topLevelRepeater.model = model.entries;
        subLevelRepeater.model = model.entries[model.index].entries;
        menuL2Title.text = model.entries[model.index].label;
    }




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
            id: topLevelRepeater

            MenuEntryL1
            {
                id: menuItem
                width: root.width
                menuModel: root.model
                model: modelData
                label: modelData.label
                icon: modelData.icon
            }
        }
    }

    Rectangle
    {
        id: subLevel
        color: Regovar.theme.primaryColor.back.normal
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.leftMargin: root.width
        width: root.width - 50
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

                Text
                {
                    id: icon
                    width: 50
                    height: 49
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: Regovar.theme.icons.name
                    font.pixelSize: 22
                    text: "]"
                    color: Regovar.theme.primaryColor.back.dark
                }
                Text
                {
                    id: menuL2Title
                    height: 49
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 22
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
                id: subLevelRepeater

                MenuEntryL2
                {
                    id: menu2Item
                    width: subLevel.width
                    menuModel: root.model
                    model: modelData
                    label: modelData.label
                    icon: modelData.icon
                }
            }
        }
    }

    Rectangle
    {
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
            anchors.fill: parent
            hoverEnabled: true
            onEntered: collapseIcon.color = Regovar.theme.secondaryColor.back.normal
            onExited: collapseIcon.color = Regovar.theme.primaryColor.back.light
            onClicked:
            {
                root.model.collapsed = !root.model.collapsed;

                if (root.model.collapsed)
                {
                    mainMenu.width = 50;
                    collapseIcon.text = "s";
                    subLevel.visible = false;
                }
                else
                {
                    mainMenu.width = expandWidth;
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



    Behavior on width
    {
        NumberAnimation
        {
            duration : 150
        }
    }

    states: [
        State
        {
            name: "level0"
            PropertyChanges { target: mainMenu; width: root.model.collapsed ? 50 : 250}
            PropertyChanges { target: subLevel; anchors.leftMargin: root.width }
        },
        State
        {
            name: "level1"
            PropertyChanges { target: mainMenu; width: root.model.collapsed ? 50 : 250}
            PropertyChanges { target: subLevel; anchors.leftMargin: 50}
        },
        State
        {
            name: "minified"
            PropertyChanges { target: mainMenu; width: 50}
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
                property: "anchors.leftMargin"
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
                property: "anchors.leftMargin"
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
    ]
}
