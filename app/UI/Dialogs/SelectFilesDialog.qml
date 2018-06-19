import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0
import QtGraphicalEffects 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Dialog
{
    id: fileDialog
    title: qsTr("Select your files")
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 500
    height: 400
    signal fileSelected(var files)
    property alias remoteIndex: remoteFiles.currentRow
    property alias remoteSelection: remoteFiles.selection
    property bool enableImportLocalFile: true
    property alias searchQuery: searchInput.text




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
            text: qsTr("You can select in the list below files that have already been uploaded on the server.\nOtherwise, you can import new files by uploading them from your computer.")
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
                id: searchInput
                Layout.fillWidth: true
                iconLeft: "z"
                displayClearButton: true
                placeholder: qsTr("Search file by name, date, comment, ...")
                onTextEdited: regovar.filesManager.remoteList.proxy.setFilterString(text)
            }

            TableView
            {
                id: remoteFiles
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.filesManager.remoteList.proxy
                selectionMode: SelectionMode.ExtendedSelection


                TableViewColumn
                {
                    title: "Name"
                    role: "name"
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
                    role: "status"
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
                TableViewColumn { title: "Size"; role: "size" }
                TableViewColumn { title: "Date"; role: "updateDate" }
                TableViewColumn { title: "Comment"; role: "comment" }
            }
        }


        ButtonIcon
        {
            id: remoteSwitchButton
            anchors.bottom : root.bottom
            anchors.left: root.left
            anchors.margins: 10

            iconTxt: "à"
            text: qsTr("Upload local files")
            onClicked: localFilesDialog.open()
            visible: enableImportLocalFile
            enabled: enableImportLocalFile
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
                var files = [];
                // Get list of selected files
                remoteFiles.selection.forEach( function(rowIndex)
                {
                    var idx = regovar.filesManager.remoteList.proxy.getModelIndex(rowIndex);
                    var id = regovar.filesManager.remoteList.data(idx, 257); // 257 = Qt::UserRole+1
                    files = files.concat(regovar.filesManager.getOrCreateFile(id));
                });

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
            text: qsTr("Cancel")
            onClicked: fileDialog.reject()
        }
    }



    FileDialog
    {
        id: localFilesDialog
        nameFilters: ["All files (*)"]
        selectedNameFilter: "All files (*)"
        title: "Select file(s) to upload on the server"
        selectMultiple: true
        onAccepted: Regovar.importFiles(fileUrls)
    }


    function reset()
    {
        remoteFiles.selection.select(0);
    }

}


