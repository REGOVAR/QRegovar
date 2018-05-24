import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Dialog
{
    id: infoDialog
    modality: Qt.WindowModal



    width: 300
    height: 150

    property alias text: infoLabel.text
    property alias icon: infoIcon.text
    signal ok()

    contentItem: Rectangle
    {
        id: root
        color: Regovar.theme.backgroundColor.main



        RowLayout
        {
            anchors.top: root.top
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: okButton.top
            anchors.margins: 10

            spacing: 10

            Text
            {
                id: infoIcon
                Layout.fillHeight: true
                width:  100
                text: "j"
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: 50
                font.family: Regovar.theme.icons.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text
            {
                id: infoLabel
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



        Button
        {
            id: okButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.margins: 10

            text: qsTr("Ok")
            onClicked:
            {
                infoDialog.ok();
                infoDialog.close();
            }
        }
    }
}
