import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"
    property string iconText: "µ"
    width: 1.5 * Regovar.theme.font.boxSize.title + textElmt.width
    height: Regovar.theme.font.boxSize.title


    contentItem: Row
    {
        anchors.fill: control
        Text
        {
            font.pixelSize: Regovar.theme.font.size.title
            font.family: Regovar.theme.icons.name
            color: control.hovered ? Regovar.theme.secondaryColor.front.normal : ( control.down ? Regovar.theme.secondaryColor.front.dark: Regovar.theme.secondaryColor.back.normal)
            font.weight: Font.Bold
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            height: Regovar.theme.font.boxSize.title
            width: Regovar.theme.font.boxSize.title
            text: iconText
        }
        Text
        {
            id: textElmt
            font.pixelSize: Regovar.theme.font.size.title
            font.family: Regovar.theme.font.familly
            color: control.hovered ? Regovar.theme.secondaryColor.front.normal : ( control.down ? Regovar.theme.secondaryColor.front.dark: Regovar.theme.secondaryColor.back.normal)
            verticalAlignment: Text.AlignVCenter
            height: Regovar.theme.font.boxSize.title
            text: control.text
        }
    }


    background: Rectangle
    {
        anchors.fill: control
        color : control.hovered ? Regovar.theme.secondaryColor.back.normal : ( control.down ? Regovar.theme.secondaryColor.back.dark: "transparent")

        Behavior on color
        {
            ColorAnimation
            {
               duration : 150
            }
        }
    }
}

