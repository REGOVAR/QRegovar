import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import "qrc:/qml/Regovar"

TextField
{
    id: control
    placeholderText: enabled ? control.placeholder : ""
    font.pixelSize: Regovar.theme.font.size.normal
    font.family: Regovar.theme.font.family
    color: Regovar.theme.frontColor.normal

    selectByMouse :true

    property string placeholder: qsTr("Enter description")
    property string iconLeft: ""
    property string iconLeftColor: Regovar.theme.darker(Regovar.theme.boxColor.border)
    property string iconRight: ""
    property string iconRightColor: Regovar.theme.darker(Regovar.theme.boxColor.border)
    property bool displayClearButton: false



    onIconLeftChanged:
    {
        if (iconLeft)
        {
            iconLeft.visible = true;
            control.leftPadding = iconLeft.width + 5;
        }
    }
    onIconRightChanged:
    {
        if (iconRight)
        {
            iconRight.visible = true;
            control.rightPadding = iconRight.width + 5;
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


        ButtonInline
        {
            id: clearButton
            visible: displayClearButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10 + (iconRight.visible ? iconRight.width : 0)
            iconTxt: "h"
            text: ""
            ToolTip.text: qsTr("Clear all")
            enabled: control.text != ""

            onClicked:
            {
                control.text = "";
                control.focus = true;
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
