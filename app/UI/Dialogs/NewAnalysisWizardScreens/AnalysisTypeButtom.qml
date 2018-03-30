import QtQuick 2.9
import QtGraphicalEffects 1.0

import "qrc:/qml/Regovar"
Item
{
    id: root
    property string label
    property string description
    property bool isHover: false
    property alias source: logo.source
    property int iconWidth: 300
    onIsHoverChanged: hover(isHover)

    signal clicked()
    signal hover(var isHover)

    height: iconWidth + Regovar.theme.font.boxSize.header + 10
    width: iconWidth


    Rectangle
    {
        id: box
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: iconWidth
        height: iconWidth
        clip: true

        color: Regovar.theme.boxColor.back
        border.color: (isHover) ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
        border.width: 1
        radius: 5

        Image
        {
            id: logo
            anchors.fill: parent
        }

    }
    Rectangle
    {
        id: label
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: iconWidth-0.2*iconWidth
        height: Regovar.theme.font.boxSize.header
        radius: 2

        color: (isHover) ? Regovar.theme.secondaryColor.back.normal  : Regovar.theme.primaryColor.back.light

        Text
        {
            anchors.fill: parent
            text: root.label
            color: (isHover) ? Regovar.theme.secondaryColor.front.normal  : Regovar.theme.primaryColor.front.light
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: isHover = true
        onExited: isHover = false
        onClicked: root.clicked()
    }
}
