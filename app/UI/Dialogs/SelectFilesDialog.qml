import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as OLD
import QtQml.Models 2.2
import QtQuick.Dialogs 1.2
import org.regovar 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: fileDialog
    title: qsTr("Select your files")
    standardButtons: Dialog.Ok | Dialog.Cancel

    width: 500
    height: 400


    property alias remoteIndex: remoteFiles.currentIndex
    property alias localIndex: localFiles.currentIndex
    property alias remoteSelection: remoteFiles.selection
    property alias localSelection: localFiles.selection


    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")
    Keys.onEscapePressed: root.reject()
    Keys.onBackPressed: root.reject() // especially necessary on Android


    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main

        Rectangle
        {
            id: rootRemoteView
            anchors.fill: root

            Text
            {
                id: remoteLabel
                anchors.top : rootRemoteView.top
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.margins: 10

                text: qsTr("Select files already on the server")
                font.pixelSize: Regovar.theme.font.size.control
            }

            TextField
            {
                id: remoteFilterField
                anchors.top : remoteLabel.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.margins: 10
                placeholderText: qsTr("Search file by name, date, comment, ...")
            }

            TreeView
            {
                id: remoteFiles
                anchors.top : remoteFilterField.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.bottom: remoteSwitchButton.top
                anchors.margins: 10

                model: regovar.remoteFilesTreeView
            }

            Button
            {
                id: remoteSwitchButton
                anchors.bottom : rootRemoteView.bottom
                anchors.left: rootRemoteView.left
                anchors.margins: 10

                text: qsTr("+ Upload local files")
                onClicked:
                {
                    rootRemoteView.visible = false;
                    rootLocalView.visible = true;
                }
            }
        }


        Rectangle
        {
            id: rootLocalView
            color: Regovar.theme.backgroundColor.main

            anchors.fill: root
            visible: false


            ItemSelectionModel
            {
                id: sel
                model: fileSystemModel
            }



            Text
            {
                id: localLabel
                anchors.top : rootLocalView.top
                anchors.left: rootLocalView.left
                anchors.right: rootLocalView.right
                anchors.margins: 10

                text: qsTr("Select local files to upload on the server")
                font.pixelSize: Regovar.theme.font.size.control
            }

            TextField
            {
                id: localFilterField
                anchors.top : localLabel.bottom
                anchors.left: rootLocalView.left
                anchors.right: rootLocalView.right
                anchors.margins: 10
                placeholderText: qsTr("Search file by name, date, comment, ...")
            }

            TreeView
            {
                id: localFiles
                anchors.top : localFilterField.bottom
                anchors.left: rootLocalView.left
                anchors.right: rootLocalView.right
                anchors.bottom: localSwitchButton.top
                anchors.margins: 10
                model: fileSystemModel
                rootIndex: rootPathIndex
                selection: sel
                selectionMode:2

                OLD.TableViewColumn
                {
                    title: "Name"
                    role: "fileName"
                    resizable: true
                }

                OLD.TableViewColumn
                {
                    title: "Size"
                    role: "size"
                    resizable: true
                    horizontalAlignment : Text.AlignRight
                    width: 70
                }

                OLD.TableViewColumn
                {
                    title: "Permissions"
                    role: "displayableFilePermissions"
                    resizable: true
                    width: 100
                }

                OLD.TableViewColumn
                {
                    title: "Date Modified"
                    role: "lastModified"
                    resizable: true
                }

                onActivated :
                {

                    var url = fileSystemModel.data(index, FileSystemModel.UrlStringRole);
                    Qt.openUrlExternally(url);
                }
            }


            Button
            {
                id: localSwitchButton
                anchors.bottom : rootLocalView.bottom
                anchors.left: rootLocalView.left
                anchors.margins: 10

                text: qsTr("< Back to remote files")
                onClicked:
                {
                    rootLocalView.visible = false;
                    rootRemoteView.visible = true;
                }
            }
        }



        Button
        {
            id: okButton
            anchors.bottom : root.bottom
            anchors.right: root.right
            anchors.margins: 10

            text: qsTr("Ok")
            onClicked: fileDialog.accept()
        }

        Button
        {
            id: cancelButton
            anchors.bottom : root.bottom
            anchors.right: okButton.left
            anchors.margins: 10
            text: qsTr("Cancel")
            onClicked: fileDialog.reject()
        }
    }
}


