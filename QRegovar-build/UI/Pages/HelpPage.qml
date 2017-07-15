import QtQuick 2.7
import "../Framework"
import "../Regovar"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main

    Column
    {
        anchors.margins: 10
        spacing: 10
        Text
        {
           text: "HELP"
           font.pointSize: 24
        }

        Button
        {
            text: "Enabled"
        }

        Button
        {
            text: "Disabled"
            enabled: false
        }

        TextField
        {
            placeholderText: "Search Project by name..."
        }

        TextField
        {
            placeholderText: "Disabled..."
            enabled: false
        }
    }
}
