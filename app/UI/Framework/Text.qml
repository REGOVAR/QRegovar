import QtQuick 2.7
import "../Regovar"


Text
{
    id: control
    font.pixelSize: Regovar.theme.font.size.content
    font.family: Regovar.theme.font.familly
    color: enabled ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
}
