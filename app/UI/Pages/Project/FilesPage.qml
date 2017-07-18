import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"


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
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter

            text: regovar.currentProject.name
        }
    }

    Column
    {
        id: actionsPanel
        anchors.top: header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: addFile
            text: qsTr("Add file")
            onClicked:  popupAddFile.open()
        }

        Button
        {
            id: editFile
            text: qsTr("Edit file")
            onClicked: editSelectedFile()
        }

        Button
        {
            id: deleteFile
            enabled: false
            text: qsTr("Delete file")
        }
    }


    TreeView
    {
        id: filesList
        anchors.left: root.left
        anchors.top: header.bottom
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        model: regovar.currentProject.files

        // Default delegate for all column
        itemDelegate: Item
        {
            Text
            {
                anchors.leftMargin: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                text: styleData.value.text
                elide: Text.ElideRight
            }
        }

        TableViewColumn {
            role: "name"
            title: "Name"
        }

        TableViewColumn {
            role: "status"
            title: "Status"
//            delegate: Item
//            {
//                Text
//                {
//                    anchors.fill: parent
//                    color: "red"
//                    text: styleData.row + ": " + styleData.column + " = " + styleData.value
//                }
//            }
        }

        TableViewColumn {
            role: "size"
            title: "Size"
        }

        TableViewColumn {
            role: "date"
            title: "Date"
        }

        TableViewColumn {
            role: "comment"
            title: "Comment"
        }
    }

}
