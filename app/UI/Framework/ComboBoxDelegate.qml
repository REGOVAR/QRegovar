import QtQuick 2.7
import QtQuick.Controls 2.2
import "../Regovar"

ItemDelegate
{
    id: item
    height: Regovar.theme.font.boxSize.control
    width: parent.width

    property var combobox

    Rectangle
    {
        id: root
        anchors.fill: parent
        color: Regovar.theme.boxColor.back

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: combobox.activated(index)
            onEntered: root.color = Regovar.theme.secondaryColor.back.light
            onExited: root.color = Regovar.theme.boxColor.back
        }
    }
}
