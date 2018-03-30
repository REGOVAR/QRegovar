import QtQuick 2.9
import QtQuick.Controls.Styles 1.4
import "qrc:/qml/Regovar"


Text
{
    id: control
    font.pixelSize: Regovar.theme.font.size.normal
    font.family: Regovar.theme.font.family
    color: enabled ? Regovar.theme.frontColor.normal : disableColor
    property var disableColor: Regovar.theme.frontColor.disable
}
