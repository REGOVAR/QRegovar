import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle
{
    id: root
    height: 22
    width: content.width -2
    color: index % 2 == 0 ? Style.backgroundColor : Style.boxBackColor

    property alias contentItem: itemDelegate.contentItem

    Binding {
        target: itemDelegate
        property: "contentItem"
        value: root.delegate
    }



    ItemDelegate
    {
        id: itemDelegate
        anchors.fill: root

        Text
        {
            verticalAlignment: Text.AlignVCenter
            text: "1" // root.model.index
            font.pixelSize: Style.fontSizeContent
            font.family: Style.fontFamilly
            color: Style.mainFontColor
            anchors.margins: 4
        }
    }
}
