import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../Regovar"

Rectangle
{
    id:root

    property string icon: "k"
    property string text: "A text box"
    property string mainColor: Regovar.theme.frontColor.info

    color: Regovar.theme.lighter(root.mainColor)
    border.width: 1
    border.color: root.mainColor
    height: max(logo.height, message.height)

    FontLoader { id: iconsFont; source: "../Icons.ttf" }

    RowLayout
    {
        id: layout
        anchors.fill: root
        anchors.margins: 5


        Text
        {
            id: logo
            width: 30
            height: 20
            Layout.minimumWidth: 30
            Layout.minimumHeight: 20

            text: root.icon
            font.family: iconsFont.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: mainColor
        }

        Text
        {
            id: message
            Layout.minimumWidth: 30
            Layout.minimumHeight: 20
            Layout.fillWidth: true
            text: root.text
            color: Regovar.theme.darker(root.mainColor)
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }
    }

}
