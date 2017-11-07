import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../Regovar"

Rectangle
{
    id: root

    property string icon: "k"
    property string text: "A text box"
    property string mainColor: Regovar.theme.frontColor.info

    color: Regovar.theme.lighter(root.mainColor)
    border.width: 1
    border.color: root.mainColor
    height: message.height + 10

    FontLoader { id: iconsFont; source: "../Icons.ttf" }

    Text
    {
        id: logo
        width: Regovar.theme.font.boxSize.header
        height: Regovar.theme.font.boxSize.normal
        anchors.left: root.left
        anchors.top: root.top


        text: root.icon
        font.family: iconsFont.name
        font.pixelSize: Regovar.theme.font.size.normal
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: mainColor
    }

    Text
    {
        id: message
        anchors.left: logo.right
        anchors.right: root.right
        anchors.top: root.top
        anchors.margins: 5
        anchors.leftMargin: 0
        onHeightChanged: root.height = height + 10

        text: root.text
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.darker(root.mainColor)
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
}
