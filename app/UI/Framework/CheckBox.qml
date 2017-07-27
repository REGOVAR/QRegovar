import QtQuick 2.7
import QtQuick.Controls 2.0

import "../Regovar"

CheckBox {
    id: control
    text: qsTr("CheckBox")
    checked: true

    FontLoader
    {
        id : iconFont
        source: "../Icons.ttf"
    }

    indicator: Rectangle
    {
        implicitWidth:20
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 5
        color : control.enabled && control.checked  ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.light

        Label
        {

            text:"n"
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 12
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
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
