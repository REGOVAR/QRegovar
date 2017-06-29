import QtQuick 2.0
import QtQuick.Controls 2.1

Button
{
    id: control
    text: "A Special Button"


    contentItem: Text {
        text: control.text
        font.pixelSize: 16
        font.family: "Roboto"
        color:Style.light
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        radius: 4
        color : control.down ? Style.darker(Style.primary) : Style.primary

        Behavior on color {

            ColorAnimation {
               duration : 200
            }
        }
    }


}
