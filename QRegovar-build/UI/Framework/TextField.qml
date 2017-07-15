import QtQuick 2.7
import QtQuick.Controls 2.0
import "../Framework" as Controls
import "../Regovar"

TextField
{
    id: control
    placeholderText: qsTr("Enter description")
    font.pixelSize: Regovar.theme.font.size.control
    font.family: Regovar.theme.font.familly

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: 35
        border.width: 1
        border.color: control.focus ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.boxColor.border
        color: Regovar.theme.boxColor.back
    }
}
