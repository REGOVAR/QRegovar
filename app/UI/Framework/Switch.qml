import QtQuick 2.7
import QtQuick.Controls 2.0


Switch {
    id: control
    text: qsTr("Switch")

    indicator: Rectangle {
        implicitWidth: 60
        implicitHeight: 26
        x: 0
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? Style.primary: "lightgray"

        Rectangle {
            x: control.checked ? parent.width - width - 3 : 3
            y: 3
            width: 20
            height: 20
            radius: 13
            color: control.down ? "#cccccc" : "#ffffff"

            Behavior on x {
                NumberAnimation {
                    duration : 200
                }
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#17a81a" : "#21be2b"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
