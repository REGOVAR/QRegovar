import QtQuick 2.0
import QtQuick.Controls 2.1
import "../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema
import "../components/controls"

Rectangle
{
    id: root

    color: ColorTheme.backgroundColor

    Column
    {
        Rectangle
        {
            id: header
            height: 50
            width: root.width
            color: ColorTheme.background2Color


            TextInput
            {
                anchors.fill: header
                anchors.margins: 16

            }
        }
    }
}
