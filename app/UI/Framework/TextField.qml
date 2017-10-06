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
    property string iconLeftColor: Regovar.theme.frontColor.normal
    property string iconRight: ""
    property string iconRightColor: Regovar.theme.frontColor.normal

    onIconLeftChanged:
    {
        if (iconLeft)
        {
            iconLeftText.visible = true
            control.leftPadding = Regovar.theme.font.size.normal
        }
    }
    onIconRightChanged:
    {
        if (iconRight)
        {
            iconRightText.visible = true
            control.rightPadding = Regovar.theme.font.size.normal
        }
    }

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: Regovar.theme.font.boxSize.normal
        border.width: enabled ? 1 : 0
        border.color: control.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
        color: enabled ? Regovar.theme.boxColor.back : "transparent"

        Text
        {
            id:  iconLeftText
            height: Regovar.theme.font.boxSize.normal
            width: Regovar.theme.font.boxSize.normal
            anchors.top: parent.top
            anchors.left: parent.left
            text: control.iconLeft
            visible: false
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.normal
            color: iconLeftColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text
        {
            id:  iconRightText
            height: Regovar.theme.font.boxSize.normal
            width: Regovar.theme.font.boxSize.normal
            anchors.top: parent.top
            anchors.right: parent.right
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
