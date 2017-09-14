import QtQuick 2.0

import "../../Regovar"
Item
{
    id: root
    property string label
    property string description
    property bool isHover: false
    property alias source: animation.source
    onIsHoverChanged: hover(isHover)

    signal clicked()
    signal hover(var isHover)

    height: 200 + Regovar.theme.font.boxSize.header/2
    width: 200


    Rectangle
    {
        id: box
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 200
        clip: true

        color: Regovar.theme.boxColor.back
        border.color: (isHover) ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
        border.width: 1
        radius: 5

        AnimatedImage
        {
            id: animation
            anchors.fill: parent
        }

    }
    Rectangle
    {
        id: label
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width-50
        height: Regovar.theme.font.boxSize.header

        color: (isHover) ? Regovar.theme.secondaryColor.back.normal  : Regovar.theme.primaryColor.back.light

        Text
        {
            anchors.fill: parent
            text: root.label
            color: (isHover) ? Regovar.theme.secondaryColor.front.normal  : Regovar.theme.primaryColor.front.light
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
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
