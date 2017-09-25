import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

import "../Regovar"
import "../Framework"








Dialog
{
    id: sampleDialog
    title: qsTr("Select your samples")
    standardButtons: Dialog.Ok | Dialog.Cancel

    width: 800
    height: 600

//    property alias localIndex: localFiles.currentIndex
//    property alias localSelection: localFiles.selection
//    property alias remoteSampleTreeModel: remoteSamples.model
//    property alias remoteIndex: remoteSamples.currentIndex
//    property alias remoteSelection: remoteSamples.selection


    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")

    signal samplesSelected(var samples)



    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main
        anchors.fill: parent

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

//                Image
//                {
//                    id: remoteLogo
//                    anchors.top : parent.top
//                    anchors.left: parent.left
//                    anchors.margins: 10
//                    width: 80
//                    height: 80

//                    source: "qrc:/logo.png"
//                    ColorOverlay
//                    {
//                        anchors.fill: parent
//                        source: remoteLogo
//                        color: Regovar.theme.primaryColor.front.normal
//                    }
//                }
                Text
                {
                    anchors.top : parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    width: 80
                    height: 80

                    text: "4"
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


                    text: qsTr("Regovar samples")
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

                    text: qsTr("You can select samples that are already on the server.\nYou can also import new samples by uploading a (g)vcf file.")
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
                placeholderText: qsTr("Search sample by identifiant or vcf filename, subject's name, birthday, sex, comment, ...")
            }

            TableView
            {
                id: remoteSamples
                anchors.top : remoteFilterField.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.bottom: remoteSwitchButton.top
                anchors.margins: 10

                model: regovar.remoteSamplesList
                selectionMode: SelectionMode.ExtendedSelection
                Component.onCompleted: regovar.loadSampleBrowser(2);
                property var statusIcons: ["m", "/", "n", "h"]

                TableViewColumn { title: qsTr("Sample"); role: "name"; horizontalAlignment: Text.AlignLeft; }
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
                            text: remoteSamples.statusIcons[styleData.value.status]
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
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subjectUI"
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
                            text: styleData.value.sex == "M" ? "9" : styleData.value.sex == "F" ? "<" : ""
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
                            text: styleData.value.lastname + " " + styleData.value.firstname + "(" + styleData.value.age + ")"
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn
                {
                    title: qsTr("Source")
                    role: "sourceUI"
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
                TableViewColumn { title: qsTr("Comment"); role: "comment" }
            }

            ButtonIcon
            {
                id: remoteSwitchButton
                anchors.bottom : rootRemoteView.bottom
                anchors.left: rootRemoteView.left
                anchors.margins: 10

                icon: "µ"
                text: qsTr("Import sample from file")
                onClicked:
                {
                    rootRemoteView.visible = false;
                    rootFileView.visible = true;
                }
            }
        }


        Rectangle
        {
            id: rootFileView
            color: Regovar.theme.backgroundColor.main

            anchors.fill: root
            visible: false


            Rectangle
            {
                id: localHeader
                anchors.top : rootFileView.top
                anchors.left: rootFileView.left
                anchors.right: rootFileView.right
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


                    text: qsTr("Import samples from file")
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

                    text: qsTr("Select the file(s) from which you want to import samples.\nYou can add file that are already uploaded on the regovar server or drop your (g)vcf file here to start the upload on the server.")
                    font.pixelSize: Regovar.theme.font.size.control
                    color: Regovar.theme.primaryColor.front.normal
                }
            }

            RowLayout
            {
                spacing: 10
                anchors.top : localHeader.bottom
                anchors.left: rootFileView.left
                anchors.right: rootFileView.right
                anchors.bottom: localSwitchButton.top
                anchors.margins: 10



                TableView
                {
                    id: inputsList
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: regovar.newPipelineAnalysis.inputsFilesList


                    Rectangle
                    {
                        id: dropAreaFeedBack
                        anchors.fill: parent;
                        color: "#99ffffff"
                        visible: false
                        Text
                        {
                            anchors.centerIn: parent
                            text: qsTr("Drop your (g)vcf files here !")
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
                            regovar.enqueueUploadFile(files);
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
                                verticalAlignment: Text.AlignVCenter
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
                                font.pixelSize: Regovar.theme.font.size.control
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
                                files = files.concat(regovar.remoteFilesList[rowIndex]);
                            });
                            regovar.newPipelineAnalysis.removeInputs(files);
                        }
                    }
                }
            }




            ButtonIcon
            {
                id: localSwitchButton
                anchors.bottom : rootFileView.bottom
                anchors.left: rootFileView.left
                anchors.margins: 10

                icon: "]"
                text: qsTr("Back to remote samples")
                onClicked:
                {
                    rootFileView.visible = false;
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
                var samples=[];
                if (rootRemoteView.visible)
                {
                    remoteSamples.selection.forEach( function(rowIndex)
                    {
                        samples = samples.concat(regovar.remoteSamplesList[rowIndex]);
                    });
                    samplesSelected(samples);
                }

                else if (rootFileView.visible)
                {

{"msg": "import_vcf_start", "data": {"samples": [{"id": 62, "name": "BIL_M_pere"}, {"id": 63, "name": "RIC_C_mere"}, {"id": 61, "name": "BIL_L"}], "file_id": "25"}}
                }

//                if (rootFileView.visible)
//                {
//                    // First retrieve local files url
//                    for(var i=0; i<localFiles.selection.selectedIndexes.length; i++)
//                    {
//                        var idx = localFiles.selection.selectedIndexes[i];
//                        var url = fileSystemModel.data(idx, FileSystemModel.UrlStringRole);
//                        files = files.concat(url);
//                    }

//                    // Start tus upload for
//                    console.log("Start upload of files : " + files);
//                    regovar.enqueueUploadFile(files);

//                    // Retrieve
//                    // No need to send "fileSelected(files)" signal as the tus upload will auto add it to the inputsList
//                    // TODO : find a better way to manage it to avoid multiuser problem and so on...
//                }


                sampleDialog.accept();
            }
        }

        Button
        {
            id: cancelButton
            anchors.bottom : root.bottom
            anchors.right: okButton.left
            anchors.margins: 10
            text: qsTr("Cancel")
            onClicked: sampleDialog.reject()
        }
    }


    SelectFilesDialog
    {
        id: fileSelector
        onFileSelected: { regovar.newPipelineAnalysis.addInputs(files); }
    }

    Connections
    {
        target: regovar
        onOnWebsocketMessageReceived:
        {
            // We assume that if a file is downloading, it's for us...
            if (action == "file_upload")
            {
                regovar.newPipelineAnalysis.addInputFromWS(data);
            }

            console.log ("WS [" + action + "] " + data);
        }
    }
}


