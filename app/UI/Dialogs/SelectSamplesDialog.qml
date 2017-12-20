import QtQuick 2.9
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
        // => answer create sample object into regovar.analysesManager.newFiltering.samples
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

                    onCurrentIndexChanged:
                    {
                        regovar.samplesManager.referencialId = regovar.references[currentIndex].id;
                    }
                }

                TextField
                {
                    Layout.fillWidth: true
                    anchors.leftMargin: 10 + (referencialSelectorEnabled ? refCombo.width + 10 : 0)
                    placeholder: qsTr("Search sample by identifiant or vcf filename, subject's name, date of birth, sex, comment, ...")
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
                            text: styleData.value.subjectUI.sex
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
                            text: styleData.value.subjectUI.name
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
                            text: styleData.value ? styleData.value.icon : ""
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
                            text: styleData.value ? styleData.value.filename : ""
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
                        text: qsTr("No sample complient with the reference ") + regovar.analysesManager.newFiltering.refName + qsTr(" on the server Regovar.\nTo import new samples from files click on the button below.")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.normal
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
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
                text: qsTr("Select the vcf file(s) from which you want to import samples.\nYou can select file that are already on the regovar server or upload news ones.")
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

                    model: regovar.analysesManager.newFiltering.samplesInputsFilesList

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

//                                onTextChanged:
//                                {
//                                    if (styleData.value.status == 1) // 1 = Loading
//                                    {
//                                        statusIconAnimation2.start();
//                                    }
//                                    else
//                                    {
//                                        statusIconAnimation2.stop();
//                                    }
//                                }
//                                NumberAnimation on rotation
//                                {
//                                    id: statusIconAnimation2
//                                    duration: 1000
//                                    loops: Animation.Infinite
//                                    from: 0
//                                    to: 360
//                                }
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

                        visible: regovar.analysesManager.newFiltering.samplesInputsFilesList.length == 0

                        Text
                        {
                            text: qsTr("Click on the \"Add file\" button to select vcf file.")
                            font.pixelSize: Regovar.theme.font.size.header
                            color: Regovar.theme.primaryColor.back.normal
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
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
                                files = files.concat(regovar.analysesManager.newFiltering.samplesInputsFilesList[rowIndex]);
                            });
                            regovar.analysesManager.newFiltering.removeSampleInputs(files);
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
                // OK Clicked from "Remote sample" view
                if (rootRemoteView.visible)
                {
                    remoteSamples.selection.forEach( function(rowIndex)
                    {
                        samples = samples.concat(regovar.samplesManager.samplesList[rowIndex]);
                    });
                    samplesSelected(samples);
                }
                // OK Clicked from "Remote files" view
                else if (rootFileView.visible)
                {
                    // import all file
                    for(var idx=0; idx<regovar.analysesManager.newFiltering.samplesInputsFilesList.length; idx++)
                    {
                        var file = regovar.analysesManager.newFiltering.samplesInputsFilesList[idx];
                        regovar.analysesManager.newFiltering.addSamplesFromFile(file.id);
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
        uploadBlocking: true
        onFileSelected: regovar.analysesManager.newFiltering.addSampleInputs(files);

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


