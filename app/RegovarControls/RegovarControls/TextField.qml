import QtQuick 2.6
import QtQuick.Controls 2.0
import FlatUIRegovarControls 1.0

TextField {
    id: control
    placeholderText: qsTr("Enter description")

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        border.width: 2
        border.color: control.focus ? Style.primary : "lightgray"
        radius: 6
    }
}
