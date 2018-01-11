import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: questionDialog
    modality: Qt.WindowModal



    width: 300
    height: 150

    property alias text: questionLabel.text
    property alias icon: questionIcon.text
    signal yes()
    signal no()

    contentItem: Rectangle
    {
        id: root
        color: Regovar.theme.backgroundColor.main



        RowLayout
        {
            anchors.top: root.top
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: controlButtons.top
            anchors.margins: 10

            spacing: 10

            Text
            {
                id: questionIcon
                Layout.fillHeight: true
                width:  100
                text: "i"
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: 50
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text
            {
                id: questionLabel
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Your text..."
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
        }


        Rectangle
        {
            id: controlButtons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: yesButton.width + noButton.width + 30
            height: yesButton.height + 20
            color: "transparent"

            Button
            {
                id: noButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: 10

                text: qsTr("No")
                onClicked:
                {
                    questionDialog.no();
                    questionDialog.close();
                }
            }
            Button
            {
                id: yesButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 10

                text: qsTr("Yes")
                onClicked:
                {
                    questionDialog.yes();
                    questionDialog.close();

                }
            }
        }
    }
}
