import QtQuick 2.9
import QtQuick.Controls 2.2
import RegovarControls 1.0

Button
{
    id: control
    text: "Button"


    contentItem: Text
    {
        text: control.text
        font.pixelSize: Style.fontSizeControl
        font.family: Style.fontFamilly
        color: Style.secondaryFrontColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle
    {
        implicitWidth: 100
        implicitHeight: 32
        color : control.down ? Style.secondaryDarkBackColor : Style.secondaryBackColor

        Behavior on color
        {
            ColorAnimation
            {
               duration : 200
            }
        }
    }
}

