import QtQuick 2.7
import QtQuick.Controls 2.0

import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

Rectangle
{
    id: parent

    color: ColorTheme.backgroundColor


    ListView
    {
        anchors.fill: parent


        model: 100


    }
}
