import QtQuick 2.9
import "../../Regovar"
import "../../Framework"

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
            font.family: Regovar.theme.font.family
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter

            text: "regovar.currentProject.name"
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }

    Image
    {
        anchors.top: header.bottom
        anchors.left: root.left

        source: "qrc:/a130 Project Subjects.png"
    }

}
