import QtQuick 2.7
import "../../Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10

            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: regovar.currentProject.name
        }
    }

    Text
    {
       text: "RESUME"
       font.pointSize: 24
       anchors.centerIn: parent
    }
}
