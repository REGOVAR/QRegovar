import QtQuick 2.7
import QtQuick.Controls 2.0

CheckBox {
    id: control
    text: qsTr("CheckBox")
    checked: true

    FontLoader {
        id : iconFont
        source: "fonts/flat-ui-icons-regular.ttf"
    }

    indicator: Rectangle {
        implicitWidth:20
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 5
        color : control.enabled && control.checked  ? Style.primary : "lightgray"

        Label {

            text:"\ue60a"
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 12
            font.family: iconFont.name
            visible: control.checked ? true : false
        }

        Behavior on color {

            ColorAnimation {

                duration: 200
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: Style.dark
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
