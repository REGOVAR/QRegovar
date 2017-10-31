import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2 as Control

import "../Regovar"
import "../Framework"








Dialog
{
    id: sampleDialog
    title: qsTr("Select your samples")
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 800
    height: 600
    property bool referencialSelectorEnabled: true
    signal samplesSelected(var samples)

    onAccepted:
    {
        // sample/import/file
        // => answer create sample object into regovar.newFilteringAnalysis.samples
        //
        console.log("Ok clicked")
    }
    onRejected: console.log("Cancel clicked")




    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main
        anchors.fill: parent

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

                iconText: "4"
                title: qsTr("Regovar samples")
                text:  qsTr("You can select samples that are already on the server.\nYou can also import new samples by uploading a (g)vcf file.")
            }

            RowLayout
            {
                id: remoteFilterField
                anchors.top : remoteHeader.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.margins: 10
                spacing: 10

                Text
                {
                    text: qsTr("Referencial:")
                    enabled: referencialSelectorEnabled
                    color: Regovar.theme.primaryColor.back.normal
                }

                ComboBox
                {
                    id: refCombo
                    enabled: referencialSelectorEnabled
                    anchors.top : remoteHeader.bottom
                    anchors.right: rootRemoteView.right
                    anchors.margins: 10
                    model:regovar.references
                    textRole: "name"

                    delegate: Control.ItemDelegate
                    {
                        x: 1
                        width: refCombo.width -2
                        height: Regovar.theme.font.boxSize.normal
                        contentItem: Text
                        {
                            text: modelData.name
                            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
                            font: refCombo.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: refCombo.highlightedIndex === index
                    }
                }

                TextField
                {
                    Layout.fillWidth: true
                    anchors.leftMargin: 10 + (referencialSelectorEnabled ? refCombo.width + 10 : 0)
                    placeholderText: qsTr("Search sample by identifiant or vcf filename, subject's name, date of birth, sex, comment, ...")
                }
            }





            TableView
            {
                id: remoteSamples
                anchors.top : remoteFilterField.bottom
                anchors.left: rootRemoteView.left
                anchors.right: rootRemoteView.right
                anchors.bottom: remoteSwitchButton.top
                anchors.margins: 10

                model: regovar.samplesManager.samplesList
                selectionMode: SelectionMode.ExtendedSelection
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
                            font.pixelSize: Regovar.theme.font.size.normal
                            font.family: Regovar.theme.icons.name
                            text: remoteSamples.statusIcons[styleData.value.status]
                            onTextChanged:
                            {
                                if (styleData.value.status == 1) // 1 = Loading
                                {
                                    statusIconAnimation.start();
                                }
                                else
                                {
                                    statusIconAnimation.stop();
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
                TableViewColumn
                {
                    title: qsTr("Subject")
                    role: "subject"
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
                            text: styleData.value ? styleData.value.subjectUI.sex : ""
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
                            text: styleData.value ? styleData.value.subjectUI.name : ""
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
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.icon
                            font.family: Regovar.theme.icons.name
                        }
                        Text
                        {
                            anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.filename
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn { title: qsTr("Comment"); role: "comment" }

                Rectangle
                {
                    id: sampleHelpPanel
                    anchors.fill: parent

                    color: "#aaffffff"

                    visible: regovar.samplesManager.samplesList.length == 0

                    Text
                    {
                        text: qsTr("No sample complient with the reference ") + regovar.newFilteringAnalysis.refName + qsTr(" on the server Regovar.\nTo import new samples from files click on the button below.")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    Text
                    {
                        anchors.left: parent.left
                        anchors.bottom : parent.bottom
                        anchors.leftMargin:Math.max(0, remoteSwitchButton.width / 2 - width/2)
                        text: "â"
                        font.family: Regovar.theme.icons.name
                        font.pixelSize: 30
                        color: Regovar.theme.primaryColor.back.normal

                        NumberAnimation on anchors.bottomMargin
                        {
                            duration: 2000
                            loops: Animation.Infinite
                            from: 30
                            to: 0
                            easing.type: Easing.SineCurve
                        }
                    }
                }
            }

            ButtonIcon
            {
                id: remoteSwitchButton
                anchors.bottom : rootRemoteView.bottom
                anchors.left: rootRemoteView.left
                anchors.margins: 10

                icon: "à"
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


            DialogHeader
            {
                id: localHeader
                anchors.top : rootFileView.top
                anchors.left: rootFileView.left
                anchors.right: rootFileView.right
                iconText: "1"
                title: qsTr("Import samples from file")
                text: qsTr("Select the vcf file(s) from which you want to import samples.\nYou can add file that are already uploaded on the regovar server or drop your (g)vcf file here to start the upload on the server.")
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
                            else
                            {
                                dropOkLabel.visible = false;
                                dropKoLabel.visible = true;
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
                        onExited:
                        {
                            dropAreaFeedBack.visible = false;
                            dropOkLabel.visible = true;
                            dropKoLabel.visible = false;
                        }
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
                                font.family: Regovar.theme.icons.name
                                text: remoteSamples.statusIcons[styleData.value.status]
                                onTextChanged:
                                {
                                    if (styleData.value.status == 1) // 1 = Loading
                                    {
                                        statusIconAnimation2.start();
                                    }
                                    else
                                    {
                                        statusIconAnimation2.stop();
                                    }
                                }
                                NumberAnimation on rotation
                                {
                                    id: statusIconAnimation2
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

                    Rectangle
                    {
                        id: fileHelpPanel
                        anchors.fill: parent

                        color: "#aaffffff"

                        visible: regovar.newPipelineAnalysis.inputsFilesList.length == 0

                        Text
                        {
                            text: qsTr("Drop your vcf file here, or click on the adjacent button to select vcf file already on the Regovar server.")
                            font.pixelSize: Regovar.theme.font.size.header
                            color: Regovar.theme.primaryColor.back.normal
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                        }
                        Text
                        {
                            anchors.right: parent.right
                            anchors.top : parent.top
                            text: "ä"
                            font.family: Regovar.theme.icons.name
                            font.pixelSize: 30
                            color: Regovar.theme.primaryColor.back.normal

                            NumberAnimation on anchors.rightMargin
                            {
                                duration: 2000
                                loops: Animation.Infinite
                                from: 30
                                to: 0
                                easing.type: Easing.SineCurve
                            }
                        }
                    }
                    Rectangle
                    {
                        id: dropAreaFeedBack
                        anchors.fill: parent;
                        color: Regovar.theme.boxColor.back
                        border.width: 1
                        border.color: Regovar.theme.boxColor.border
                        visible: false
                        Text
                        {
                            id: dropOkLabel
                            anchors.centerIn: parent
                            text: qsTr("Drop your (g)vcf files here !")
                            font.pixelSize: Regovar.theme.font.size.header
                            color: Regovar.theme.primaryColor.back.normal
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                        }
                        Text
                        {
                            id: dropKoLabel
                            text: qsTr("Sorry, only vcf, gvcf, vcf.gz and gvcf.gz file are supported to import sample.")
                            font.pixelSize: Regovar.theme.font.size.header
                            color: Regovar.theme.primaryColor.back.normal
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            visible: false
                        }
                    }
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
                        samples = samples.concat(regovar.samplesManager.samplesList[rowIndex]);
                    });
                    samplesSelected(samples);
                }

                else if (rootFileView.visible)
                {
                    // import all file
                    for(var idx=0; idx<regovar.newPipelineAnalysis.inputsFilesList.length; idx++)
                    {
                        var file = regovar.newPipelineAnalysis.inputsFilesList[idx];
                        regovar.newFilteringAnalysis.addSamplesFromFile(file.id);
                    }
                }

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
        }
    }


    function reset()
    {
        // init the dialog with the currently selected ref in the model
        var idx = 0;
        for (idx=0; idx<regovar.references.length; idx++)
        {
            if (regovar.references[idx].id == regovar.samplesManager.referencialId)
            {
                break;
            }
            refCombo.currentIndex = idx;
        }

        rootRemoteView.visible = true;
        rootFileView.visible = false;

    }
}


