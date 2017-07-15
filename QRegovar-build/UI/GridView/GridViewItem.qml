import QtQuick 2.7
import QtQuick.Controls 2.0

import "../Regovar"

Rectangle
{
    id: root
    height: 22
    width: content.width -2
    color: index % 2 == 0 ? Regovar.theme.backgroundColor.main : Regovar.theme.boxColor.back

    property alias contentItem: itemDelegate.contentItem
    property var model: null

    Binding {
        target: itemDelegate
        property: "contentItem"
        value: root.delegate
    }



    ItemDelegate
    {
        id: itemDelegate
        anchors.fill: root

        contentItem: Text
        {
            verticalAlignment: Text.AlignVCenter
            text: qsTr("You need to provide delegate to display information by row")
            font.pixelSize: Regovar.theme.font.size.content
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            anchors.margins: 4
        }
    }
}
