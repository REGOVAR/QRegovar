import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "../Regovar"

TextArea
{
    implicitHeight: 3 * Regovar.theme.font.boxSize.control
    style: TextAreaStyle
    {
        textColor: enabled ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
        selectionColor: Regovar.theme.secondaryColor.back.light
        selectedTextColor: Regovar.theme.secondaryColor.front.light
        backgroundColor: enabled ? Regovar.theme.boxColor.back : "transparent"

        frame: Rectangle
        {
            color: enabled ? Regovar.theme.boxColor.back : "transparent"
            border.width: enabled ? 1 : 0
            border.color: Regovar.theme.boxColor.border
        }
    }
}
