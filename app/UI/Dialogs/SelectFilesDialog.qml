import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0
import QtGraphicalEffects 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: fileDialog
    title: qsTr("Upload your files")
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 500
    height: 400
    signal fileSelected(var files)
    property alias remoteIndex: remoteFiles.currentRow
    property alias remoteSelection: remoteFiles.selection

    //! if true: uploading new files will block the UI untill the upload is finished.
    property bool uploadBlocking: false
    property string uploadBlockingOkButtonLabel: qsTr("Uploading") + " (0%)"
    property int uploadingProgress: regovar.filesManager.uploadsProgress
    onUploadingProgressChanged:
    {
        if (uploadingProgress<100)
            uploadBlockingOkButtonLabel = qsTr("Uploading") + " (" + uploadingProgress + "%)";
        else
            uploadBlockingOkButtonLabel = qsTr("Upload done");
    }


    onVisibleChanged: if (visible) reset();
    Component.onCompleted: regovar.filesManager.loadFilesBrowser()


    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main


        DialogHeader
        {
            id: header
            anchors.top : root.top
            anchors.left: root.left
            anchors.right: root.right
            iconImage: "qrc:/logo.png"
            title: qsTr("Regovar files")
            text: qsTr("You can select files that are already on the server.\nYou can also import new files by uploading them from your computer.")
        }

        ColumnLayout
        {
            anchors.top : header.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: remoteSwitchButton.top
            anchors.margins: 10
            spacing: 10


            TextField
            {
                Layout.fillWidth: true
                placeholder: qsTr("Search file by name, date, comment, ...")
            }

            TableView
            {
                id: remoteFiles
                Layout.fillWidth: true
                Layout.fillHeight: true

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
            }
        }

        Rectangle
        {
            id: uploadBlockingProgress
            anchors.top : header.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom: remoteSwitchButton.top
            anchors.margins: 10
            color: Regovar.theme.backgroundColor.main
            visible: false

            // Prevent clicks on the layer underneath
            MouseArea { anchors.fill: parent; propagateComposedEvents: false; }


            ColumnLayout
            {
                anchors.fill : parent
                spacing: 10


                Box
                {
                    Layout.fillWidth: true
                    height: 30
                    mainColor: Regovar.theme.frontColor.warning
                    icon: "m"
                    text: qsTr("Upload in progress. Please wait until it finishes before continuing.")
                }

                TableView
                {
                    id: uploadingFiles
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: regovar.filesManager.uploadsList
                    selectionMode: SelectionMode.ExtendedSelection


                    TableViewColumn
                    {
                        title: "Name"
                        role: "filenameUI"
                        delegate: Item
                        {
                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                anchors.rightMargin: 5
                                spacing: 5

                                // TODO: File upload play/pause/cancel button
//                                ButtonInline
//                                {
//                                    iconTxt: "y"
//                                    text: ""
//                                    ToolTip.text: qsTr("Pause upload of this file")
//                                    ToolTip.visible: hovered
//                                }
//                                ButtonInline
//                                {
//                                    iconTxt: "h"
//                                    text: ""
//                                    ToolTip.text: qsTr("Cancel upload of this file")
//                                    ToolTip.visible: hovered
//                                }

                                Text
                                {
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: styleData.textAlignment
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    text: styleData.value.icon
                                    font.family: Regovar.theme.icons.name
                                }
                                Text
                                {
                                    Layout.fillWidth: true
                                    horizontalAlignment: styleData.textAlignment
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    text: styleData.value.filename
                                    elide: Text.ElideRight
                                }
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

                                onTextChanged:
                                {
                                    if (styleData.value.status == 0) // 0 = Loading
                                    {
                                        statusIconAnimation.start();
                                    }
                                    else
                                    {
                                        statusIconAnimation.stop();
                                        rotation = 0;
                                    }
                                }
                                NumberAnimation on rotation
                                {
                                    id: statusIconAnimation
                                    duration: 1000
                                    loops: Animation.Infinite
                                    from: 0
                                    to: 360
                                }
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
                    TableViewColumn { title: "Comment"; role: "comment" }

                }
            }

        }

        ButtonIcon
        {
            id: remoteSwitchButton
            anchors.bottom : root.bottom
            anchors.left: root.left
            anchors.margins: 10

            visible: !uploadBlockingProgress.visible

            iconTxt: "à"
            text: qsTr("Upload local files")
            onClicked: localFilesDialog.open()
        }


        Button
        {
            id: okButton
            anchors.bottom : root.bottom
            anchors.right: root.right
            anchors.margins: 10
            text: !uploadBlockingProgress.visible ? qsTr("Ok") : uploadBlockingOkButtonLabel

            enabled: !uploadBlockingProgress.visible || uploadingProgress >= 100

            onClicked:
            {
                var files = [];
                // OK Clicked from "Upload Blocking" View
                if (uploadBlockingProgress.visible)
                {
                    // Get list of selected files = list of uploaded files
                    for (var idx=0; idx<regovar.filesManager.uploadsList.length; idx++)
                    {
                        files = files.concat(regovar.filesManager.uploadsList[idx]);
                    }
                }
                // OK Clicked from "Remote files" View
                else
                {
                    // Get list of selected files
                    remoteFiles.selection.forEach( function(rowIndex)
                    {
                        files = files.concat(regovar.filesManager.remoteList[rowIndex]);
                    });
                }


                // Return / emit result
                fileSelected(files);
                fileDialog.accept();
            }
        }

        Button
        {
            id: cancelButton
            anchors.bottom : root.bottom
            anchors.right: okButton.left
            anchors.margins: 10
            text: !uploadBlockingProgress.visible ? qsTr("Cancel") : qsTr("Cancel all uploads")

            enabled: !uploadBlockingProgress.visible || uploadingProgress < 100
            onClicked:
            {
                // CANCEL Clicked from "Upload Blocking" View
                if (uploadBlockingProgress.visible)
                {
                    // Clear uploading files list in the model
                    var files = [];
                    for (var idx=0; idx<regovar.filesManager.uploadsList.length; idx++)
                    {
                        files = files.concat(regovar.filesManager.uploadsList[idx].id);
                    }
                    regovar.filesManager.cancelUploadFile(files);
                }

                // Return / emit result
                fileDialog.reject()
            }
        }
    }


    function reset()
    {
        // Force Collapse "Upload Blocking" View
        uploadBlockingProgress.visible = false;

        // Force Clear uploading files list in the model (TUS manager queue/inprogress is not impacted)
        regovar.filesManager.clearUploadsList();

        // Reset selection in the remote view
        remoteFiles.selection.select(0);
    }


    FileDialog
    {
        id: localFilesDialog
        nameFilters: [ "VCF files (*.vcf *.vcf.gz)", "GVCF (*.gvcf *.gvcf.gz)", "All files (*)" ]
        selectedNameFilter: "VCF files (*.vcf *.vcf.gz)"
        title: "Select file(s) to upload on the server"
        //folder: shortcuts.home
        selectMultiple: true

        onAccepted: importFiles(localFilesDialog.fileUrls)
    }

    function importFiles(files)
    {
        console.log("Start upload of files : " + files);
        var filesToImport = [];
        for (var idx=0; idx<files; idx++)
        {
            var file = files[idx];
            if (file in fileUploadList) continue;
            filesToImport.push(file);
            fileUploadList.push(file);
        }

        // Enqueue file to the TUS upload manager.
        // When upload will start, the fileManager will emit uploadsChanged signal
        // We will be able to retrieve created File & Sample entries in the model
        // and update the view accordingly (see connection below)
        regovar.filesManager.enqueueUploadFile(filesToImport);
    }
}


