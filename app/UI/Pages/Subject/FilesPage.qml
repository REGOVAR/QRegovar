import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


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
            onClicked:  fileDialog.open()
        }

        Button
        {
            id: editFile
            text: qsTr("Edit file")
            onClicked: customPopup.open()
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




    Popup
    {
        id: customPopup
        implicitWidth: root.width / 3 * 2
        implicitHeight: root.height / 3 * 2
        x: (root.width - width) / 2
        y: 20
        modal: true
        focus: true

        property alias title: popupLabel.text

        contentItem: ColumnLayout
        {
            id: settingsColumn
            spacing: 20

            // Popup title
            Label
            {
                id: popupLabel
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // File path
            TextField
            {
                id: field
                placeholderText: "File path..."
                implicitWidth: parent.width
            }

            // Buttons.
            RowLayout
            {
                spacing: 10

                Button
                {
                    id: okButton
                    text: "Ok"
                    onClicked: { onOkClicked(); close();}

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }

                Button
                {
                    id: cancelButton
                    text: "Cancel"
                    onClicked: { state = false; }

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }



    SelectFilesDialog
    {
        id: fileDialog
        visible: false
        title: qsTr("Please choose a file")
//        folder: shortcuts.home

        onAccepted:
        {
            var list = fileSystemModel.getFilesPath(localSelection)
            regovar.enqueueUploadFile(list)
        }
    }


}
