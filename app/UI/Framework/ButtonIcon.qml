import QtQuick 2.9
import QtQuick.Controls 2.0
import "qrc:/qml/Regovar"

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


    contentItem: Row
    {
        spacing: (iconTxt != "" && control.text != "") ? 5 : 0
        Text
        {
            id: iconText
            text: iconTxt
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.icons.name
            font.bold: false
            color: Regovar.theme.secondaryColor.front.normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            width: iconTxt ? Regovar.theme.font.size.normal : 0
            visible: iconTxt != ""
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
        implicitWidth: Regovar.theme.font.boxSize.normal + 4
        implicitHeight: Regovar.theme.font.boxSize.normal + 4
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

