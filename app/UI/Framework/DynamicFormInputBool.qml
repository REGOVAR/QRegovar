import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../Regovar"


GridLayout
{
    id: root
    columnSpacing: 10
    rowSpacing: 5
    columns: 2
    rows: 2

    property var model

    Text
    {
        elide: Text.ElideRight
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.dark
        text: model ? model["name"] : "?"
    }

    CheckBox
    {
        id: input
        Layout.fillWidth: true
    }

    Text
    {
        Layout.row: 1
        Layout.column: 1
        Layout.fillWidth: true
        text: model ? model["description"] : ["?"]
        font.pixelSize: Regovar.theme.font.size.small
        font.italic: true
        color: Regovar.theme.primaryColor.back.normal
        wrapMode: Text.WordWrap
    }
}
