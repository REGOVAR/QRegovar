import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"

    onWidthChanged: bg.width = width


    property var baseColor: Regovar.theme.boxColor.back
    property var borderColor: Regovar.theme.boxColor.border
    property var textColor: Regovar.theme.primaryColor.back.dark

    contentItem: Text
    {
        text: control.text
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.icons.name
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        color: control.textColor
    }


    background: Rectangle
    {
        id: bg
        implicitHeight: Regovar.theme.font.boxSize.normal
        color : !enabled ? Regovar.theme.boxColor.disabled : down ? Regovar.theme.secondaryColor.back.dark: hovered?Regovar.theme.secondaryColor.back.light : baseColor

        radius: 2
        border.width: 1
        border.color: control.borderColor

        Behavior on color
        {
            ColorAnimation
            {
               duration : 100
            }
        }
    }
}

