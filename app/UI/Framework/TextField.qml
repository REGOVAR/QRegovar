import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Framework" as Controls
import "../Style"

TextField
{
    id: control
    placeholderText: qsTr("Enter description")
    font.pixelSize: Style.font.size.control
    font.family: Style.font.familly

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: 35
        border.width: 1
        border.color: control.focus ? Style.secondaryColor.back.normal : Style.boxColor.border
        color: Style.boxColor.back
    }
}
