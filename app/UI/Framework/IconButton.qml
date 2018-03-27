import QtQuick 2.0
import QtQuick.Controls 2.2

import "qrc:/qml/Regovar"

Text
{
    id: control
    property bool hovered: false
    property string tooltip: ""
    property color colorMain: Regovar.theme.secondaryColor.back.normal
    property color colorHover: Regovar.theme.secondaryColor.back.light
    property color colorDown: Regovar.theme.secondaryColor.back.dark
    property color colorDisabled: Regovar.theme.boxColor.disabled
    signal clicked()

    width: Regovar.theme.font.boxSize.normal
    height: Regovar.theme.font.boxSize.normal
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    text: "i"
    color: !enabled ? control.colorDisabled : hovered ? control.colorHover : control.colorMain
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
