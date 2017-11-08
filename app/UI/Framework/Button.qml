import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"


    contentItem: Text
    {
        text: control.text
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.font.familly
        font.bold: false
        color: Regovar.theme.secondaryColor.front.normal
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }


    background: Rectangle
    {
        implicitWidth: 100
        implicitHeight: 24
        color : !control.enabled ? Regovar.theme.boxColor.disabled : control.down ? Regovar.theme.secondaryColor.back.dark: control.hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.secondaryColor.back.normal

        radius: 2

        Behavior on color
        {
            ColorAnimation
            {
               duration : 100
            }
        }
    }
}

