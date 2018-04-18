import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "qrc:/qml/Regovar"

TextArea
{
    id: control
    property color colorBack: Regovar.theme.boxColor.back
    property color colorBackDisable: "transparent"
    property color colorText: Regovar.theme.frontColor.normal
    property color colorTextDisable: Regovar.theme.frontColor.disable
    property color colorBorder: Regovar.theme.boxColor.border
    property color colorSelection: Regovar.theme.secondaryColor.back.light
    property color colorTextSelection: Regovar.theme.secondaryColor.front.light

    font.pixelSize: Regovar.theme.font.size.normal

    implicitHeight: 3 * Regovar.theme.font.boxSize.normal
    style: TextAreaStyle
    {
        textColor: enabled ? control.colorText : control.colorTextDisable
        selectionColor: control.colorSelection
        selectedTextColor: control.colorTextSelection
        backgroundColor: enabled ? control.colorBack : control.colorBackDisable
        textMargin: 5

        frame: Rectangle
        {
            color: "transparent"
            border.width: enabled ? 1 : 0
            border.color: control.colorBorder
            radius: 2
        }
    }
}
