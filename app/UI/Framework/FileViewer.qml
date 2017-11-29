import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0
import "../Regovar"
import "FileViewers"

Rectangle
{
    color: "transparent"
    clip: true


    function openFile(id)
    {
        viewer.visible = true;
        viewer.file = regovar.filesManager.getOrCreateFile(id);
    }


    ColumnLayout
    {
        id: rightPanel
        anchors.fill: parent
        anchors.leftMargin: 10
        spacing: 10

        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            RowLayout
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10

                Text
                {
                    id: rightPanelHeader
                    Layout.fillWidth: true
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    text: qsTr("Current document")
                    elide: Text.ElideRight
                }

                Row
                {
                    spacing: 10

                    ButtonInline
                    {
                        text: ""
                        icon: "\""
                    }
                    ButtonInline
                    {
                        text: ""
                        icon: "é"
                    }
                }
            }



            Rectangle
            {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }
        }

        Rectangle
        {
            id: emptyPanel
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"


            Text
            {
                anchors.centerIn: parent
                text: "Select a document"
                font.pixelSize: Regovar.theme.font.size.title
                color: Regovar.theme.primaryColor.back.light
            }
        }

        TxtViewer
        {
            id: viewer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Regovar.theme.backgroundColor.normal
            visible: false

        }
    }
}
