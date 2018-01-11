import QtQuick 2.9
import QtQuick.Controls.Styles 1.4
import "../Regovar"


Text
{
    id: control
    font.pixelSize: Regovar.theme.font.size.normal
    font.family: Regovar.theme.font.family
    color: enabled ? Regovar.theme.frontColor.normal : disableColor
    property var disableColor: Regovar.theme.frontColor.disable
}

//TextArea
//{
//    id: control
//    font.pixelSize: Regovar.theme.font.size.small
//    font.family: Regovar.theme.font.family

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
