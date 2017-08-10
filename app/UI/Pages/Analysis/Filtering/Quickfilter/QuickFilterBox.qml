import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.alt
//    border.width: 1
//    border.color: Regovar.theme.boxColor.border
    height: isExpanded ? content.height + header.height : header.height

    property FilteringAnalysis model
    property real maxHeight: content.height + 30
    property string title
    property bool isEnabled
    property bool isExpanded
    property Item content

    FontLoader
    {
        id : iconFont
        source: "../../../../Icons.ttf"
    }

    Rectangle
    {
        id: header
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right

        height: 30
        color: Regovar.theme.backgroundColor.main


        Text
        {
            id: activeIcon
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            width: 30
            text: "n"
            font.family: iconFont.name
            font.pixelSize: Regovar.theme.font.size.header
            color: isEnabled ? Regovar.theme.primaryColor.back.dark : Regovar.theme.primaryColor.back.light
            verticalAlignment: Text.AlignVCenter

        }

        Text
        {
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.left: header.left
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            anchors.right: header.right

            text: title
            elide: Text.ElideRight
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
        }

        Text
        {
            id: collapseIcon
            anchors.top: header.top
            anchors.bottom: header.bottom
            anchors.right: header.right
            width: 30
            height: 30
            text: "{"
            font.family: iconFont.name
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            rotation: isExpanded ? 90 : 0
        }

        MouseArea
        {
            anchors.fill: parent
            cursorShape: "PointingHandCursor"
            onClicked:
            {
                console.log("click");
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
        visible: isExpanded
    }
}
