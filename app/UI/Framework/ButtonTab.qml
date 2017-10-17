import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"

    onWidthChanged: bg.width = width


    property var baseColor: Regovar.theme.secondaryColor.back.normal

    contentItem: Text
    {
        text: control.text
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.icons.name
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }


    background: Rectangle
    {
        id: bg
        implicitHeight: Regovar.theme.font.boxSize.normal
        color : !enabled ? Regovar.theme.boxColor.disabled : down ? Regovar.theme.secondaryColor.back.dark: hovered?Regovar.theme.secondaryColor.back.light : baseColor

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

