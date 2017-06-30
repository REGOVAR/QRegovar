import QtQuick 2.5
import QtQuick.Controls 2.0
import FlatUIRegovarControls 1.0

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
        color: Style.light
        radius: 5
    }

    contentItem: Item
    {
        implicitWidth: background.implicitWidth
        implicitHeight: background.implicitHeight

        Rectangle
        {
            width: control.visualPosition * background.width
            height: parent.height
            radius: 5
            color: Style.warning

            Label
            {
                text:control.value * 100 + "%"
                color: "white"
                font.family: "Roboto"
                anchors.centerIn: parent
                font.pixelSize: 12

            }
        }
    }
}
