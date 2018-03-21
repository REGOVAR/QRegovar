import QtQuick 2.9
import QtQuick.Controls 2.0
import "../Regovar"

Button
{
    id: control
    text: "Button"
    height: Regovar.theme.font.boxSize.normal

    property color colorText: Regovar.theme.secondaryColor.front.normal
    property color colorMain: Regovar.theme.secondaryColor.back.normal
    property color colorHover: Regovar.theme.secondaryColor.back.light
    property color colorDown: Regovar.theme.secondaryColor.back.dark
    property color colorDisabled: Regovar.theme.boxColor.disabled
    property string iconTxt: ""
    onIconTxtChanged:
    {
        if (iconTxt != null && iconTxt != undefined && iconTxt != "")
        {
            iconText.visible = true
            iconText.width = Regovar.theme.font.boxSize.normal
        }
    }


    contentItem: Row
    {
        anchors.verticalCenter: parent.verticalCenter
        Text
        {
            id: iconText
            //height: control.height
            text: iconTxt
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.icons.name
            font.bold: false
            color: Regovar.theme.secondaryColor.front.normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: 0
            visible: false
        }
        Text
        {
            //height: control.height
            text: control.text
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            font.bold: false
            color: colorText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }


    background: Rectangle
    {
        implicitWidth: 100
        implicitHeight: control.height
        color : !control.enabled ? colorDisabled : control.down ? colorDown : control.hovered ? colorHover : colorMain
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

