import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true


    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Select the file(s) you want to analyse. You can select files that are already available on the server, or upload your own files.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
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
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.frontColor.normal
        }
        RowLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true


            TableView
            {
                id: inputsList
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.newPipeline.inputsFilesList


                Rectangle
                {
                    id: dropAreaFeedBack
                    anchors.fill: parent;
                    color: "#99ffffff"
                    visible: false
                    Text
                    {
                        anchors.centerIn: parent
                        text: qsTr("Drop your files here")
                    }
                }

                DropArea
                {
                    id: dropArea;
                    anchors.fill: parent;
                    onEntered:
                    {
                        if (drag.hasUrls)
                        {
                            dropAreaFeedBack.visible = true;
                            drag.accept (Qt.CopyAction);
                        }
                    }
                    onDropped:
                    {
                        var files= []
                        for(var i=0; i<drop.urls.length; i++)
                        {
                            files = files.concat(drop.urls[i]);
                        }
                        regovar.filesManager.enqueueUploadFile(files);
                        dropAreaFeedBack.visible = false;
                    }
                    onExited: dropAreaFeedBack.visible = false;
                }

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
                            verticalAlignment: Text.AlignVCenter
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
                TableViewColumn { title: "Size"; role: "sizeUI"; horizontalAlignment: Text.AlignRight }
                TableViewColumn
                {
                    title: "Date"
                    role: "updateDate"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text:styleData.value.toLocaleDateString()
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn { title: "Source"; role: "sourceUI" }
                TableViewColumn { title: "Comment"; role: "comment" }
            }




            Column
            {
                Layout.alignment: Qt.AlignTop
                spacing: 10
                Button
                {
                    id: addButton
                    text: qsTr("Add file")
                    onClicked: { fileSelector.reset(); fileSelector.open(); }
                }
                Button
                {
                    id: remButton
                    text: qsTr("Remove file")
                    onClicked:
                    {
                        // Get list of objects to remove
                        var files= []
                        inputsList.selection.forEach( function(rowIndex)
                        {
                            files = files.concat(regovar.filesManager.remoteList[rowIndex]);
                        });
                        regovar.newPipeline.removeInputs(files);
                    }
                }
            }
        }
    }


    SelectFilesDialog
    {
        id: fileSelector
        onFileSelected: { regovar.newPipeline.addInputs(files); }
    }

    Connections
    {
        target: regovar
        onOnWebsocketMessageReceived:
        {
            // We assume that if a file is downloading, it's for us...
            if (action == "file_upload")
            {
                regovar.newPipeline.addInputFromWS(data);
            }

            console.log ("WS [" + action + "] " + data);
        }
    }
}
