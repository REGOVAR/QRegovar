import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: questionDialog
    modality: Qt.WindowModal


    width: 400
    height: 200

    property string text
    property string icon
    signal yes()
    signal no()

    contentItem: Rectangle
    {
        id: root
        color: Regovar.theme.backgroundColor.main



        RowLayout
        {
            anchors.top: root.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: okButton.top
            anchors.margins: 10

            spacing: 10

            Text
            {
                text: questionDialog.icon
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.title
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                height:  Regovar.theme.font.boxSize.title
                width:  Regovar.theme.font.boxSize.title
            }
            Text
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop
                text: questionDialog.text
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
        }


        Rectangle
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: yesButton.width + noButton.width + 30
            height: yesButton.height + 20
            color: "transparent"

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
        }
    }
}
