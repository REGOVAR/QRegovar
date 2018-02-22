import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"
import "../Common"

Rectangle
{
    id: root

    property bool expanded: false
    property alias title: title.text
    property alias contentItem: container.contentItem

    visible: root.expanded
    implicitWidth: 200
    implicitHeight: Regovar.theme.font.boxSize.header
    height: root.expanded ? Regovar.theme.font.boxSize.header + container.height : Regovar.theme.font.boxSize.header
    color: "transparent"
    clip: true



    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.right: root.right
        height: Regovar.theme.font.boxSize.header
        color: "transparent"

        RowLayout
        {
            anchors.fill: header

            Text
            {
                text: root.expanded ? "[" : "{"
                width: Regovar.theme.font.boxSize.normal
                height: Regovar.theme.font.boxSize.header

                font.family: Regovar.theme.icons.name
                color: Regovar.theme.primaryColor.back.normal
                font.pixelSize: Regovar.theme.font.size.normal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text
            {
                id: title
                Layout.fillWidth: true
                text: "-"
                height: Regovar.theme.font.boxSize.header
                color: Regovar.theme.primaryColor.back.normal
                font.pixelSize: Regovar.theme.font.size.normal
                verticalAlignment: Text.AlignVCenter
            }
        }
        MouseArea
        {
            anchors.fill: header
            onClicked: root.expanded = !root.expanded
            cursorShape: "PointingHandCursor"
        }
    }

    Rectangle
    {
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.bottom: root.bottom
        anchors.margins: 5
        anchors.topMargin: -5
        visible: root.expanded
        width: 1
        color: Regovar.theme.primaryColor.back.light
    }
    Rectangle
    {
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.margins: 5
        visible: root.expanded
        width: 5
        height: 1
        color: Regovar.theme.primaryColor.back.normal
    }

    Container
    {
        id: container
        anchors.left: root.left
        anchors.right: root.right
        anchors.top: header.bottom
        anchors.leftMargin: Regovar.theme.font.boxSize.normal - 5
    }
}
