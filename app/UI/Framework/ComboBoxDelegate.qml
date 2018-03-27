import QtQuick 2.9
import QtQuick.Controls 2.2
import "qrc:/qml/Regovar"

ItemDelegate
{
    id: item
    height: Regovar.theme.font.boxSize.normal
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
