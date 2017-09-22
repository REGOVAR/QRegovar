import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: closeDialog
    title: qsTr("Close")

    width: 300
    height: 200


    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main

        Rectangle
        {
            id: header
            color: Regovar.theme.primaryColor.back.dark
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 50

            Text
            {
                anchors.centerIn: parent
                text: "Close Regovar"
                color: Regovar.theme.primaryColor.front.dark
                font.family: "Sans"
                font.weight: Font.Black
                font.pixelSize: Regovar.theme.font.size.header
            }
        }

        RowLayout
        {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            spacing: 10
            Button
            {
                text: qsTr("Disconnect")
                onClicked: regovar.disconnectUser()
            }
            Button
            {
                text: qsTr("Quit")
                onClicked: regovar.quit()
            }
            Button
            {
                text: qsTr("Cancel")
                onClicked: closeDialog.close()
            }
        }
    }
}
