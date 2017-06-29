import QtQuick 2.5
import QtQuick.Controls 2.1
import "../../RegovarTheme.js" as ColorTheme // @dridk : to fix, nice and dynamic loading of theme color schema

TextField
{
    id: control

    text: "salut"
    background: Rectangle
    {
        implicitHeight: 35
        border.width: 1
        border.color: ColorTheme.BoxBorderColor
        color : ColorTheme.BoxBackColor
    }
}
