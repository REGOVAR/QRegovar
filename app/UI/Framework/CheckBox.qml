import QtQuick 2.9
import QtQuick.Controls 2.0

import "qrc:/qml/Regovar"

CheckBox
{
    id: control
    text: qsTr("CheckBox")
    checked: true
    property var color: Regovar.theme.frontColor.normal


    font.pixelSize: Regovar.theme.font.size.normal

    FontLoader
    {
        id : iconFont
        source: "../Icons.ttf"
    }

    indicator: Rectangle
    {
        implicitWidth: Regovar.theme.font.size.normal + 4
        implicitHeight: Regovar.theme.font.size.normal + 4
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 2
        color : control.enabled && control.checked  ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.light

        Label
        {

            text:"n"
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: iconFont.name
            visible: control.checked ? true : false
        }

        Behavior on color
        {
            ColorAnimation
            {
                duration: 150
            }
        }
    }

    contentItem: Text
    {
        text: control.text
        font: control.font
        color: control.color
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
        elide: Text.ElideRight
    }
}
