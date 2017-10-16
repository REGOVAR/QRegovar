import QtQuick 2.7
import QtQuick.Controls 2.0
import "../../../Regovar"
import "../../../Framework"

Button
{
    id: control
    text: "Button"
    property string iconText: "à"

    ToolTip.visible: hovered
    ToolTip.delay: 500
    ToolTip.text: qsTr("Save the active filter")

    contentItem: Row
    {
        spacing: 10
        Text
        {
            font.pixelSize: Regovar.theme.font.size.title
            font.family: Regovar.theme.icons.name
            color: !control.enabled ? Regovar.theme.frontColor.disable : control.hovered ? Regovar.theme.secondaryColor.front.normal : ( control.down ? Regovar.theme.secondaryColor.front.dark: Regovar.theme.secondaryColor.back.normal)
            font.weight: Font.Bold
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: iconText
            height: textElmt.height
        }
        Text
        {
            id: textElmt
            font.pixelSize: Regovar.theme.font.size.title
            font.family: Regovar.theme.font.familly
            color: !control.enabled ? Regovar.theme.frontColor.disable :  control.hovered ? Regovar.theme.secondaryColor.front.normal : ( control.down ? Regovar.theme.secondaryColor.front.dark: Regovar.theme.secondaryColor.back.normal)
            verticalAlignment: Text.AlignVCenter
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

