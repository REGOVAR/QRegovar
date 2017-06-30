import QtQuick 2.0
import RegovarControls 1.0
import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: root

    color: ColorTheme.backgroundColor
    Column
    {
        spacing: 10
        Text
        {
           text: "PROJECT"
           font.pointSize: 24
           anchors.centerIn: parent
        }

        ShowCase
        {

        }

    }




}
