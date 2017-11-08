import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQml.Models 2.2
import QtQuick.Dialogs 1.2
import org.regovar 1.0
import QtGraphicalEffects 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: fileDialog
    title: qsTr("Select your files")
    standardButtons: Dialog.Ok | Dialog.Cancel

    property bool sampleFile: false

    width: 500
    height: 400


    property alias remoteIndex: remoteFiles.currentRow
    property alias remoteSelection: remoteFiles.selection


    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")

    signal fileSelected(var files)

    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main

        Rectangle
        {
            id: rootRemoteView
            anchors.fill: root

            DialogHeader
            {
                id: remoteHeader
                anchors.top : rootRemoteView.top
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                iconImage: "qrc:/logo.png"
                title: qsTr("Regovar files")
                text: qsTr("You can select files that are already on the server.\nYou can also import new files by uploading them from your computer.")
            }

            TextField
            {
                id: remoteFilterField
                anchors.top : remoteHeader.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.margins: 10
                placeholderText: qsTr("Search file by name, date, comment, ...")
            }

            TableView
            {
                id: remoteFiles
                anchors.top : remoteFilterField.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.bottom: remoteSwitchButton.top
                anchors.margins: 10

                model: regovar.filesManager.remoteList
                selectionMode: SelectionMode.ExtendedSelection


                TableViewColumn
                {
                    title: "Name"
                    role: "filenameUI"
                    delegate: Item
                    {

                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.icon
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.fill: parent
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.filename
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn
                {
                    title: "Status"
                    role: "statusUI"
                    delegate: Item
                    {

                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.status == 0 ? "/" : styleData.value.status == 3 ? "l" : "n"
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.label
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn { title: "Size"; role: "sizeUI" }
                TableViewColumn { title: "Date"; role: "updateDate" }
                TableViewColumn { title: "Source"; role: "sourceUI" }
                TableViewColumn { title: "Comment"; role: "comment" }

                Component.onCompleted: regovar.filesManager.loadFilesBrowser()
            }

            ButtonIcon
            {
                id: remoteSwitchButton
                anchors.bottom : rootRemoteView.bottom
                anchors.left: rootRemoteView.left
                anchors.margins: 10

                icon: "à"
                text: qsTr("Upload local files")
                onClicked: localFilesDialog.open()
            }
        }

        Button
        {
            id: okButton
            anchors.bottom : root.bottom
            anchors.right: root.right
            anchors.margins: 10

            text: qsTr("Ok")
            onClicked:
            {
                var files=[];
                if (rootRemoteView.visible)
                {
                    remoteFiles.selection.forEach( function(rowIndex)
                    {
                        files = files.concat(regovar.filesManager.remoteList[rowIndex]);
                    });
                    fileSelected(files);
                }


                fileDialog.accept();
            }
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

    function reset()
    {
        rootRemoteView.visible = true;
        remoteFiles.selection.select(0);
    }

    FileDialog
    {
        id: localFilesDialog
        nameFilters: [ "VCF files (*.vcf *.vcf.gz)", "GVCF (*.gvcf *.gvcf.gz)", "All files (*)" ]
        selectedNameFilter: "VCF files (*.vcf *.vcf.gz)"
        title: "Select file(s) to upload on the server"
        folder: shortcuts.home
        selectMultiple: true

        onAccepted:
        {
            // Start tus upload for
            console.log("Start upload of files : " + localFilesDialog.fileUrls);
            regovar.filesManager.enqueueUploadFile(localFilesDialog.fileUrls);

            // Retrieve
            // No need to send "fileSelected(files)" signal as the tus upload will auto add it to the inputsList
            // TODO : find a better way to manage it to avoid multiuser problem and so on...
        }

    }
}


