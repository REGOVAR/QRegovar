import QtQuick 2.9
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"

    property string icon: ""
    onIconChanged:
    {
        if (icon != null && icon != undefined && icon != "")
        {
            iconText.visible = true
            iconText.width = Regovar.theme.font.boxSize.normal
        }
    }


    contentItem: Row
    {
        Text
        {
            id: iconText
            text: icon
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.icons.name
            font.bold: false
            color: Regovar.theme.secondaryColor.front.normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: 24
            width: 0
            visible: false
        }
        Text
        {
            text: control.text
            height: 24
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            font.bold: false
            color: Regovar.theme.secondaryColor.front.normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
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
               duration : 200
            }
        }
    }
}

