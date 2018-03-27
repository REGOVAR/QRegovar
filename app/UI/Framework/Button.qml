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

    contentItem: Text
    {
        height: control.height
        text: control.text
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.font.family
        font.bold: false
        color: colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
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
               duration : 100
            }
        }
    }
}

