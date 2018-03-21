import QtQuick 2.0
import QtQuick.Controls 2.2

import "../Regovar"

Text
{
    id: control
    property bool hovered: false
    property string tooltip: ""
    signal clicked()

    width: Regovar.theme.font.boxSize.normal
    height: Regovar.theme.font.boxSize.normal
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    text: "i"
    color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
    font.family: Regovar.theme.icons.name
    font.pixelSize: Regovar.theme.font.size.header

    ToolTip.text: tooltip
    ToolTip.visible: hovered
    ToolTip.delay: 250

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: control.hovered = true
        onExited: control.hovered = false
        onClicked: control.clicked()
    }
}
