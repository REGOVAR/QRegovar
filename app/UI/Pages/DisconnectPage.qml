import QtQuick 2.7
import "../Regovar"

Rectangle
{
    id: root

    color: Regovar.theme.backgroundColor.main

    Text
    {
       text: "DISCONNECT"
       font.pointSize: 24
       anchors.centerIn: parent
    }
}
