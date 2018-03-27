import QtQuick 2.9
import QtQuick.Controls 2.2
import "qrc:/qml/Regovar"

TextField
{
    id: control
    placeholderText: ""
    font.pixelSize: Regovar.theme.font.size.normal
    color: Regovar.theme.frontColor.normal
    padding: 0

    selectByMouse :true

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: Regovar.theme.font.size.normal * 2
        color: focus ? Regovar.theme.secondaryColor.back.light : "transparent"
    }
}
