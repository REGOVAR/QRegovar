import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "../Regovar"

TextArea
{
    style: TextAreaStyle
    {
        textColor: Regovar.theme.frontColor.normal
        selectionColor: Regovar.theme.secondaryColor.back.light
        selectedTextColor: Regovar.theme.secondaryColor.front.light
        backgroundColor: Regovar.theme.boxColor.back
        frame: Rectangle
        {
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
        }
    }
}
