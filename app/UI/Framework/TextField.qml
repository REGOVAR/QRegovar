import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Framework" as Controls
import "../Regovar"

TextField
{
    id: control
    placeholderText: qsTr("Enter description")
    font.pixelSize: Regovar.theme.font.size.normal
    font.family: Regovar.theme.font.familly
    color: Regovar.theme.frontColor.normal
    selectByMouse :true

    property string iconLeft: ""
    property string iconLeftColor: Regovar.theme.darker(Regovar.theme.boxColor.border)
    property string iconRight: ""
    property string iconRightColor: Regovar.theme.darker(Regovar.theme.boxColor.border)

    onIconLeftChanged:
    {
        if (iconLeft)
        {
            iconLeft.visible = true
            control.leftPadding = iconLeft.width + 10
        }
    }
    onIconRightChanged:
    {
        if (iconRight)
        {
            iconRight.visible = true
            control.rightPadding = iconRight.width + 10
        }
    }

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: Regovar.theme.font.boxSize.normal
        border.width: enabled ? 1 : 0
        border.color: control.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
        color: enabled ? Regovar.theme.boxColor.back : "transparent"
        radius: 2

        Rectangle
        {
            id:  iconLeft
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height
            width: Regovar.theme.font.boxSize.normal
            visible: false

            border.width: enabled ? 1 : 0
            border.color: control.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
            color: Regovar.theme.backgroundColor.main
            radius: 2

            Text
            {
                anchors.fill: parent
                text: control.iconLeft
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.normal
                color: control.focus ? Regovar.theme.secondaryColor.back.normal : iconLeftColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }


        Rectangle
        {
            id:  iconRight
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height
            width: Regovar.theme.font.boxSize.normal
            visible: false

            border.width: enabled ? 1 : 0
            border.color: control.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
            color: Regovar.theme.backgroundColor.main
            radius: 2

            Text
            {
                anchors.fill: parent
                text: control.iconRight
                visible: false
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.normal
                color: iconRightColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
