import QtQuick 2.9
import QtQuick.Controls 2.0
import "../../../Regovar"
import "../../../Framework"

Button
{
    id: control
    text: "Button"
    property string iconText: "à"

    ToolTip.visible: hovered
    ToolTip.delay: 0
    ToolTip.text: qsTr("Save the active filter")

    contentItem: Row
    {
        spacing: 10
        Text
        {
            font.pixelSize: Regovar.theme.font.size.title
            font.family: Regovar.theme.icons.name
            color: !control.enabled ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.secondaryColor.front.normal
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
            font.family: Regovar.theme.font.family
            color:  !control.enabled ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.secondaryColor.front.normal
            verticalAlignment: Text.AlignVCenter
            text: control.text
        }
    }


    background: Rectangle
    {
        anchors.fill: control
        color : !control.enabled ? "transparent" : control.down ? Regovar.theme.secondaryColor.back.dark : Regovar.theme.secondaryColor.back.normal
        radius: 2

        Behavior on color
        {
            ColorAnimation
            {
               duration : 150
            }
        }
    }
}

