import QtQuick 2.9
import RegovarControls 1.0
import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: root

    color: ColorTheme.backgroundColor

    Column
    {
        anchors.margins: 10
        spacing: 10
        Text
        {
           text: "PROJECT"
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
