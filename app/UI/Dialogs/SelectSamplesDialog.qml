import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2 as Control
import org.regovar 1.0

import "../Regovar"
import "../Framework"
import "../Wizards/Sample"







Dialog
{
    id: sampleDialog
    title: qsTr("Select your samples")
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 800
    height: 600

    property bool importingFile: false
    property bool referencialSelectorEnabled: true
    signal samplesSelected(var samples)




    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main
        anchors.fill: parent

        Rectangle
        {
            id: rootSampleView
            anchors.fill: root
            color: "transparent"
            visible: !importingFile
            enabled: !importingFile


            DialogHeader
            {
                id: sampleViewHeader
                anchors.top : rootSampleView.top
                anchors.left: rootSampleView.left
                anchors.right: rootSampleView.right

                iconText: "4"
                title: qsTr("Regovar samples")
                text:  qsTr("You can select samples that are already on the server.\nYou can also import new samples by uploading a (g)vcf file.")
            }

            RowLayout
            {
                id: sampleViewFiltersRow
                anchors.top : sampleViewHeader.bottom
                anchors.left: rootSampleView.left
                anchors.right: rootSampleView.right
                anchors.margins: 10
                spacing: 10

                Text
                {
                    text: qsTr("Referencial:")
                    enabled: referencialSelectorEnabled
                    color: Regovar.theme.primaryColor.back.normal
                }

                Text
                {
                    text: regovar.samplesManager.referencialId > 0 ? regovar.referenceFromId(regovar.samplesManager.referencialId).name : ""
                    enabled: referencialSelectorEnabled
                    color: Regovar.theme.primaryColor.back.normal
                    visible: !referencialSelectorEnabled
                }

                ComboBox
                {
                    id: refCombo
                    visible: referencialSelectorEnabled
                    model: regovar.references
                    textRole: "name"

//                    delegate: Control.ItemDelegate
//                    {
//                        x: 1
//                        width: refCombo.width -2
//                        height: Regovar.theme.font.boxSize.normal
//                        contentItem: Text
//                        {
//                            text: modelData.name
//                            color: enabled ? Regovar.theme.boxColor.front : Regovar.theme.frontColor.disable
//                            font: refCombo.font
//                            elide: Text.ElideRight
//                            verticalAlignment: Text.AlignVCenter
//                        }
//                        highlighted: refCombo.highlightedIndex === index
//                    }

                    onCurrentIndexChanged:
                    {
                        regovar.samplesManager.referencialId = regovar.references[currentIndex].id;
                    }
                }

                TextField
                {
                    id: searchBox
                    iconLeft: "z"
                    Layout.fillWidth: true
                    anchors.leftMargin: 10 + (referencialSelectorEnabled ? refCombo.width + 10 : 0)
                    placeholder: qsTr("Search sample by identifiant or vcf filename, subject's name, identifier, comment, ...")
                    onTextEdited: regovar.samplesManager.proxy.setFilterString(text)
                }
            }



            Button
            {
                id: importSampleButton
                anchors.top : sampleViewFiltersRow.bottom
                anchors.right: rootSampleView.right
                anchors.margins: 10

                text: qsTr("Import sample\nfrom file")
                onClicked:
                {
                    localFilesDialog.open();
                }
            }


            TableView
            {
                id: selectedSamplesTable
                anchors.top : sampleViewFiltersRow.bottom
                anchors.left: rootSampleView.left
                anchors.right: importSampleButton.left
                anchors.bottom: rootSampleView.bottom
                anchors.margins: 10
                anchors.bottomMargin: okButton.height + 20

                model: regovar.samplesManager.proxy

                sortIndicatorVisible: true
                onSortIndicatorColumnChanged: regovar.samplesManager.proxy.setSortOrder(sortIndicatorColumn, sortIndicatorOrder)
                onSortIndicatorOrderChanged:  regovar.samplesManager.proxy.setSortOrder(sortIndicatorColumn, sortIndicatorOrder)





                selectionMode: SelectionMode.ExtendedSelection
                property var statusIcons: ["m", "/", "n", "h"]


                TableViewColumn { title: qsTr("Sample"); role: "name"; horizontalAlignment: Text.AlignLeft; }
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
                            font.family: Regovar.theme.icons.name
                            text: selectedSamplesTable.statusIcons[styleData.value.status]
                            onTextChanged:
                            {
                                if (styleData.value.status == 1) // 1 = Loading
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
                            text: styleData.value ? styleData.value.sex : ""
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
                            text: styleData.value ? styleData.value.name : ""
                            elide: Text.ElideRight
                        }

                    }
                }
                TableViewColumn
                {
                    title: qsTr("Source")
                    role: "source"
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

                    color: Regovar.theme.backgroundColor.overlay

                    visible: regovar.samplesManager.count == 0

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
        }


        SampleImportView
        {
            id: sampleImportView
            anchors.fill: root
            anchors.bottomMargin: okButton.height + 20
            color: Regovar.theme.backgroundColor.main
            visible: importingFile
            enabled: importingFile

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
                // OK Clicked from "sample selection" view: import selected
                if (!sampleDialog.importingFile)
                {
                    selectedSamplesTable.selection.forEach( function(rowIndex)
                    {
                        var idx = regovar.samplesManager.proxy.getModelIndex(rowIndex);
                        var id = regovar.samplesManager.data(idx, 257); // 257 = Qt::UserRole+1

                        samples = samples.concat(regovar.samplesManager.getOrCreate(id));
                    });
                    samplesSelected(samples);
                }
                // Else, OK clicked from "import sample file" view: sample import done automaticaly on upload completed

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





    FileDialog
    {
        id: localFilesDialog
        nameFilters: [ "VCF files (*.vcf *.vcf.gz)", "GVCF (*.gvcf *.gvcf.gz)", "All files (*)" ]
        selectedNameFilter: "VCF files (*.vcf *.vcf.gz)"
        title: "Select file(s) to upload on the server"
        //folder: shortcuts.home
        selectMultiple: true

        onAccepted:
        {
            // Switch to upload/import screen if needed
            sampleDialog.importingFile = true;

            // Start tus upload for
            sampleImportView.importFiles(localFilesDialog.fileUrls);
        }
    }


    function reset()
    {
        sampleDialog.importingFile = false;

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
    }
}


