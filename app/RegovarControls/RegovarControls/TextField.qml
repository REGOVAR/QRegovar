import QtQuick 2.7
import QtQuick.Controls 2.0
import RegovarControls 1.0

TextField
{
    id: control
    placeholderText: qsTr("Enter description")
    font.pixelSize: Style.fontSizeControl
    font.family: Style.fontFamilly

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: 35
        border.width: 1
        border.color: control.focus ? Style.secondaryBackColor : Style.boxBorderColor
        color: Style.boxBackColor
    }
}
