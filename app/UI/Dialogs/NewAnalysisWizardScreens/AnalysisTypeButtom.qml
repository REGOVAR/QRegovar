import QtQuick 2.7
import QtGraphicalEffects 1.0

import "../../Regovar"
Item
{
    id: root
    property string label
    property string description
    property bool isHover: false
    property alias source: logo.source
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

        Image
        {
            id: logo
            anchors.fill: parent

//            ColorOverlay
//            {
//                anchors.fill: parent
//                source: logo
//                color: (isHover) ? Regovar.theme.secondaryColor.back.light : Regovar.theme.primaryColor.back.normal
//            }

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
            font.pixelSize: Regovar.theme.font.size.normal
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
