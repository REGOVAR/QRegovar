import QtQuick 2.9
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"

    property string icon: ""


    contentItem: Row
    {
        spacing: (icon != "" && control.text != "") ? 5 : 0
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
            height: parent.height
            width: icon ? Regovar.theme.font.size.normal : 0
            visible: icon != ""
        }
        Text
        {
            text: control.text
            height: parent.height
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            font.bold: false
            color: Regovar.theme.secondaryColor.front.normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            visible: control.text != ""
        }
    }


    background: Rectangle
    {
        implicitWidth: Regovar.theme.font.size.normal + 4
        implicitHeight: Regovar.theme.font.size.normal + 4
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

