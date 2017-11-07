import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import "../Regovar"


Text
{
    id: control
    font.pixelSize: Regovar.theme.font.size.normal
    font.family: Regovar.theme.font.familly
    color: enabled ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
}

//TextArea
//{
//    id: control
//    font.pixelSize: Regovar.theme.font.size.small
//    font.family: Regovar.theme.font.familly

//    implicitHeight: Regovar.theme.font.size.small
//    frameVisible: false
//    backgroundVisible: false


//    style: TextAreaStyle
//    {
//        textColor: enabled ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
//        selectionColor: Regovar.theme.secondaryColor.back.light
//        selectedTextColor: Regovar.theme.secondaryColor.front.light
//    }
//}
