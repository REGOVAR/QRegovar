import QtQuick 2.9
import QtQuick.Controls 2.0

import "../Regovar"

ProgressBar
{
    id: control
    value: 0.5

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: 16
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        color: Regovar.theme.boxColor.back
        border.width: 1
        border.color: Regovar.theme.boxColor.border
    }

    contentItem: Item
    {
        implicitWidth: background.implicitWidth
        implicitHeight: background.implicitHeight

        Rectangle
        {
            width: control.visualPosition * background.width
            height: parent.height
            color: Regovar.theme.secondaryColor.back.normal

            Label
            {
                text: (control.value / control.to * 100).toFixed(1) + "%"
                color: Regovar.theme.secondaryColor.front.normal
                font.family: Regovar.theme.font.family
                anchors.centerIn: parent
                font.pixelSize: Regovar.theme.font.size.small

            }
        }
    }
}
