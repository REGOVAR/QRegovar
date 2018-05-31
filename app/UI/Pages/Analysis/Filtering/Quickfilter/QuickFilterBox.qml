import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.alt
//    border.width: 1
//    border.color: Regovar.theme.boxColor.border
    height: isExpanded ? content.height + header.height + 1: header.height +1

    function reset()
    {
        console.log("TODO : override the reset method plz");
    }

    property FilteringAnalysis model
    property real maxHeight: content.height + Regovar.theme.font.boxSize.header
    property string title
    property bool isExpanded
    property Item content

    Rectangle
    {
        id: header
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right

        height: Regovar.theme.font.boxSize.header
        color: Regovar.theme.backgroundColor.main



        Text
        {
            id: collapseIcon
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            width: Regovar.theme.font.boxSize.header
            height: Regovar.theme.font.boxSize.header
            text: "{"
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.header
            color: root.enabled ? Regovar.theme.primaryColor.back.dark : Regovar.theme.frontColor.disable
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            rotation: isExpanded ? 90 : 0
        }

        Text
        {
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            anchors.leftMargin: Regovar.theme.font.boxSize.header
            anchors.rightMargin: Regovar.theme.font.boxSize.header
            anchors.right: header.right

            text: title
            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.header
            color: root.enabled ? Regovar.theme.primaryColor.back.dark : Regovar.theme.frontColor.disable
            verticalAlignment: Text.AlignVCenter
        }



        MouseArea
        {
            enabled: root.enabled
            anchors.fill: parent
            cursorShape: "PointingHandCursor"
            onClicked:
            {
                isExpanded = !isExpanded
            }
        }
    }

    Container
    {
        id: container
        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right
        contentItem: content
        visible: root.enabled && isExpanded
    }

    Rectangle
    {
        Layout.fillWidth: true
        anchors.bottom: header.bottom
        height: 1
        color: Regovar.theme.backgroundColor.alt
    }
}
