import QtQuick 2.7
import QtQuick.Controls 2.2

import "../Regovar"

Item
{
    id: tableItem

    property TableView rootTable
    property bool selected: styleData.row === rootTable.currentRow && styleData.column === rootTable.currentColumn
    property bool hovered: false
    property alias content: content.contentItem

    Container
    {
        id: content
        anchors.fill: parent

        Text
        {
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: styleData.textAlignment
            font.pixelSize: Regovar.theme.font.size.normal
            text: styleData.value ? styleData.value : ""
            elide: Text.ElideRight
        }
    }

    MouseArea
    {
        anchors.fill: parent
        propagateComposedEvents: true
        hoverEnabled: true
        onEntered: update(true)
        onExited: update(false)
        onClicked: root.forceActiveFocus();

        function update(hover)
        {
            tableItem.hovered = hover;
            root.currentColumn = styleData.column;
            root.currentRow = styleData.row;
        }
    }
}
