import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"



import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

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
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Tutorials")
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
            text: "Tutorials (from web)"
            font.pointSize: 24
        }
    }











    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked:
        {
            resultContextMenu.open()
            resultContextMenu.x = mouse.x - 10
            resultContextMenu.y = mouse.y // TODO take in account screen borders
        }
    }





}
