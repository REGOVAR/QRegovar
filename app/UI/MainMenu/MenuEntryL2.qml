import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../Regovar"

Rectangle
{
    id: root
    height: headerHeight
    clip: true

    property int headerHeight: 40
    property int sublevelListHeight: 0

    property alias icon: icon.text
    property alias label: label.text
    property bool selected
    onSelectedChanged: setState()
    property RootMenu menuModel
    property MenuEntry model
    onModelChanged:
    {
        if (model)
        {
            selected = Qt.binding(function() { return model.selected; });
            sublevelListHeight = model.entries.length * 30; // see MenuEntryL3.height
            sublevelListRepeater.model = model.entries;
            setState();
        }
    }

    function setState()
    {
        state = !selected ? "normal" : model.entries.length > 0 ? "expanded" : "selected";
    }



    RowLayout
    {
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        id: header
        height: root.headerHeight
        spacing: 0

        Text
        {
            id: icon
            Layout.minimumWidth: root.headerHeight
            height: root.headerHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.header
        }
        Text
        {
            id: label
            Layout.fillWidth: true
            height: root.headerHeight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.header
            elide: Text.ElideRight
        }
        Text
        {
            id: subLevelIndicator
            Layout.minimumWidth: root.headerHeight
            height: root.headerHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.header
            text: "{"
        }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: header
        hoverEnabled: true
        onEntered: root.state = "hover"
        onExited:  setState()
        onClicked: menuModel.select(1, index)
    }

    Column
    {
        id: sublevelList
        height: sublevelListHeight
        anchors.top: header.bottom
        anchors.left: header.left
        anchors.right: header.right

        Repeater
        {
            id: sublevelListRepeater

            MenuEntryL3
            {
                width: subLevel.width
                menuModel: root.menuModel
                model: modelData
                label: modelData.label
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
            PropertyChanges { target: root; height: headerHeight}
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
            PropertyChanges { target: root; height: headerHeight + sublevelListHeight}
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
            ColorAnimation { duration: 0 }
            NumberAnimation { target: subLevelIndicator; property: "rotation"; duration: 200; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "height"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition
        {
            from: "hover"
            to: "expanded"
            ColorAnimation { duration: 0 }
            NumberAnimation { target: subLevelIndicator; property: "rotation"; duration: 200; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "height"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition
        {
            from: "expanded"
            to: "normal"
            NumberAnimation { target: subLevelIndicator; property: "rotation"; duration: 200; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "height"; duration: 200; easing.type: Easing.InOutQuad }
        }
    ]
}
