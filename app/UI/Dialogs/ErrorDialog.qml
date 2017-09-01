import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: closeDialog
    title: qsTr("Error")

    width: 300
    height: 200


    modality: Qt.WindowModal

    property string errorCode
    property string errorMessage


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

            Row
            {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Text
                {
                    text: "~"
                    color: Regovar.theme.primaryColor.front.dark
                    font.family: Regovar.theme.icons.name
                    font.weight: Font.Black
                    font.pointSize: Regovar.theme.font.size.header
                    width: 50
                    height: 50
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignHCenter
                }

                Text
                {
                    text: qsTr("Error occured")
                    color: Regovar.theme.primaryColor.front.dark
                    font.family: "Sans"
                    font.weight: Font.Black
                    font.pointSize: Regovar.theme.font.size.header
                    height: 50
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Grid
        {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 10
            anchors.bottomMargin: 50

            columns: 2
            rows:2
            columnSpacing: 30
            rowSpacing: 10

            Text
            {
                text: qsTr("Code :")
                font.weight: Font.Black
            }
            Text
            {
                text: errorPopup.errorCode
            }
            Text
            {
                text: qsTr("Message")
                font.weight: Font.Black
            }
            Text
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                text: errorPopup.errorMessage
            }
        }

        Button
        {
            text: qsTr("Close")
            anchors.bottom: root.bottom
            anchors.horizontalCenter: root.horizontalCenter
            anchors.bottomMargin: 10

        }

    }
}
