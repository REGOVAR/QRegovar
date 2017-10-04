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

    width: 500
    height: 400


    property alias remoteIndex: remoteFiles.currentRow
    property alias localIndex: localFiles.currentIndex
    property alias remoteSelection: remoteFiles.selection
    property alias localSelection: localFiles.selection


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

            Rectangle
            {
                id: remoteHeader
                anchors.top : rootRemoteView.top
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                height: 100

                color: Regovar.theme.primaryColor.back.normal

                Image
                {
                    id: remoteIcon
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    width: 80
                    height: 80

                    source: "qrc:/logo.png"

                    ColorOverlay
                    {
                        anchors.fill: parent
                        color: Regovar.theme.primaryColor.front.normal
                        source: remoteIcon
                    }
                }

                Text
                {
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 10
                    anchors.leftMargin: 100


                    text: qsTr("Regovar files")
                    font.pixelSize: Regovar.theme.font.size.title
                    font.bold: true
                    color: Regovar.theme.primaryColor.front.normal
                    elide: Text.ElideRight
                }
                Text
                {
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    anchors.topMargin: 15 + Regovar.theme.font.size.title
                    anchors.leftMargin: 100
                    wrapMode: "WordWrap"
                    elide: Text.ElideRight

                    text: qsTr("You can select files that are already on the server.\nYou can also import new files by uploading them from your computer.")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.primaryColor.front.normal
                }
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

                model: regovar.remoteFilesList
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
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.icon
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.fill: parent
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
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
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.status == 0 ? "/" : styleData.value.status == 3 ? "l" : "n"
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value.label
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn { title: "Size"; role: "sizeUI" }
                TableViewColumn { title: "Date"; role: "updateDate" }
                TableViewColumn { title: "Source"; role: "sourceUI" }
                TableViewColumn { title: "Comment"; role: "comment" }

                Component.onCompleted: regovar.loadFilesBrowser()
            }

            ButtonIcon
            {
                id: remoteSwitchButton
                anchors.bottom : rootRemoteView.bottom
                anchors.left: rootRemoteView.left
                anchors.margins: 10

                icon: "à"
                text: qsTr("Upload local files")
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


            Rectangle
            {
                id: localLabel
                anchors.top : rootLocalView.top
                anchors.left: rootLocalView.left
                anchors.right: rootLocalView.right
                height: 100

                color: Regovar.theme.primaryColor.back.normal

                Text
                {
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    width: 80
                    height: 80

                    text: "1"
                    font.pixelSize: 80
                    font.family: Regovar.theme.icons.name
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    color: Regovar.theme.primaryColor.front.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 10
                    anchors.leftMargin: 100


                    text: qsTr("Local files")
                    font.pixelSize: Regovar.theme.font.size.title
                    font.bold: true
                    color: Regovar.theme.primaryColor.front.normal
                    elide: Text.ElideRight
                }
                Text
                {
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    anchors.topMargin: 15 + Regovar.theme.font.size.title
                    anchors.leftMargin: 100
                    wrapMode: "WordWrap"
                    elide: Text.ElideRight

                    text: qsTr("Select files on your computer. Selected files will be uploaded on the Regovar server.")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.primaryColor.front.normal
                }
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

                TableViewColumn
                {
                    title: "Name"
                    role: "fileName"
                    resizable: true
                }

                TableViewColumn
                {
                    title: "Size"
                    role: "size"
                    resizable: true
                    horizontalAlignment : Text.AlignRight
                    width: 70
                }

                TableViewColumn
                {
                    title: "Permissions"
                    role: "displayableFilePermissions"
                    resizable: true
                    width: 100
                }

                TableViewColumn
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


            ButtonIcon
            {
                id: localSwitchButton
                anchors.bottom : rootLocalView.bottom
                anchors.left: rootLocalView.left
                anchors.margins: 10

                icon: "]"
                text: qsTr("Back to remote files")
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
            onClicked:
            {
                var files=[];
                if (rootRemoteView.visible)
                {
                    remoteFiles.selection.forEach( function(rowIndex)
                    {
                        files = files.concat(regovar.remoteFilesList[rowIndex]);
                    });
                    fileSelected(files);
                }
                if (rootLocalView.visible)
                {
                    // First retrieve local files url
                    for(var i=0; i<localFiles.selection.selectedIndexes.length; i++)
                    {
                        var idx = localFiles.selection.selectedIndexes[i];
                        var url = fileSystemModel.data(idx, FileSystemModel.UrlStringRole);
                        files = files.concat(url);
                    }

                    // Start tus upload for
                    console.log("Start upload of files : " + files);
                    regovar.enqueueUploadFile(files);

                    // Retrieve
                    // No need to send "fileSelected(files)" signal as the tus upload will auto add it to the inputsList
                    // TODO : find a better way to manage it to avoid multiuser problem and so on...
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
        rootLocalView.visible = false;
        remoteFiles.selection.select(0);
    }
}


