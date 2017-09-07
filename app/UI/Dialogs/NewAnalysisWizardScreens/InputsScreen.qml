import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: inputsList.count > 0

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Select the file(s) you want to analyse. You can select files that are already available on the server, or upload your own files.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.primaryColor.back.normal
    }

    ColumnLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Text
        {
            text: qsTr("Selected files")
            font.pixelSize: Regovar.theme.font.size.control
            color: Regovar.theme.frontColor.normal
        }
        RowLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Rectangle
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Regovar.theme.boxColor.back
                border.width: 1
                border.color: Regovar.theme.boxColor.border

                ListView
                {
                    id: inputsList
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 1
                    delegate: Rectangle
                    {
                        width: inputsList.width
                        height: Regovar.theme.font.boxSize.control
                        color: index % 2 == 0 ? Regovar.theme.backgroundColor.main : "transparent"

                        Text
                        {
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter

                            text: index
                        }
                    }
                }
            }



            Column
            {
                Layout.alignment: Qt.AlignTop
                spacing: 10
                Button
                {
                    id: addButton
                    text: qsTr("Add file")
                    onClicked: { fileSelector.open(); inputsList.model = 10; }
                }
                Button
                {
                    id: remButton
                    text: qsTr("Remove file")
                    onClicked: inputsList.model = null;
                }
            }
        }
    }


    SelectFilesDialog { id: fileSelector }

}
