import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Style"

Button
{
    id: control
    text: "Button"


    contentItem: Text
    {
        text: control.text
        font.pixelSize: Style.font.size.control
        font.family: Style.font.familly
        font.bold: false
        color: Style.secondaryColor.front.normal
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle
    {
        implicitWidth: 100
        implicitHeight: 32
        color : control.down ? Style.secondaryColor.back.dark: Style.secondaryColor.back.normal

        Behavior on color
        {
            ColorAnimation
            {
               duration : 200
            }
        }
    }
}

