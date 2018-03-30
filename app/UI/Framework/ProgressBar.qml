import QtQuick 2.9
import QtQuick.Controls 2.0

import "qrc:/qml/Regovar"

ProgressBar
{
    id: control
    value: 0.5
    height: Regovar.theme.font.boxSize.normal

    background: Rectangle
    {
        x: 0
        y: parent.height / 2 - height / 2
        width: control.width
        height: Regovar.theme.font.boxSize.small - 4
        color: Regovar.theme.boxColor.alt
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        clip: true

        Rectangle
        {
            x: 1
            y: 1
            width: control.visualPosition * (parent.width - 2)
            height: parent.height - 2
            color: control.enabled ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.disable
        }
        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 4
            text: (control.value / control.to * 100).toFixed(1) + "%"
            color: Regovar.theme.secondaryColor.front.normal
            font.family: Regovar.theme.font.family
            font.pixelSize: Regovar.theme.font.size.small
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    contentItem: Item {}
}
