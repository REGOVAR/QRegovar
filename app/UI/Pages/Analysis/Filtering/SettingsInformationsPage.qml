import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

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
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Analysis settings")
            font.pixelSize: 20
            font.weight: Font.Black
        }
    }


    Rectangle
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        color: "transparent"

        Text
        {
            anchors.centerIn: parent
            text: "Basic settings (name, ref, comment, status, ...)"
            font.pointSize: 24
        }
    }






}
