import QtQuick 2.7
import QtQuick.Controls 2.0

import "../Style"

Rectangle
{
    id: root
    height: 22
    width: content.width -2
    color: index % 2 == 0 ? Style.backgroundColor.main : Style.boxColor.back

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
            font.pixelSize: Style.font.size.content
            font.family: Style.font.familly
            color: Style.frontColor.normal
            anchors.margins: 4
        }
    }
}
