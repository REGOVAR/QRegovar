import QtQuick 2.9

import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: root

    color: ColorTheme.backgroundColor

    Text
    {
       text: "SUBJECT"
       font.pointSize: 24
       anchors.centerIn: parent
    }
}

