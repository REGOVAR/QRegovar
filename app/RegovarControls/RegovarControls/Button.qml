import QtQuick 2.7
import QtQuick.Controls 2.0
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
        font.bold: false
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

