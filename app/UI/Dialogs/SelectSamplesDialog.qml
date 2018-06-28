import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2 as Control
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"







Dialog
{
    id: sampleDialog
    title: qsTr("Select your samples")
    standardButtons: Dialog.Ok | Dialog.Cancel
    width: 1100
    height: 600

    property bool importingFile: false
    property var filteringAnalysis: null
    property var subject: null
    signal samplesSelected(var samples)




    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main
        anchors.fill: parent


        DialogHeader
        {
            id: sampleViewHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            iconText: "4"
            title: qsTr("Regovar samples")
            text:  qsTr("You can select samples that are already on the server.\nYou can also import new samples by uploading a (g)vcf file.")
        }

        ColumnLayout
        {
            id: rootSampleView
            anchors.top: sampleViewHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            anchors.bottomMargin: okButton.height + 20
            visible: !importingFile
            enabled: !importingFile
            spacing: 10


            Rectangle
            {
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.normal + 20
                border.width: 1
                border.color: Regovar.theme.boxColor.border
                color: Regovar.theme.boxColor.back
                visible: filteringAnalysis === null
                radius: 2

                RowLayout
                {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text
                    {
                        text: qsTr("Referencial:")
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    ComboBox
                    {
                        id: refCombo
                        Layout.fillWidth: true
                        model: regovar.references
                        textRole: "name"
                        onCurrentIndexChanged:
                        {
                            regovar.samplesManager.referencialId = regovar.references[currentIndex].id;
                        }
                    }
                }
            }


            RowLayout
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    TextField
                    {
                        id: searchBox
                        iconLeft: "z"
                        displayClearButton: true
                        Layout.fillWidth: true
                        placeholder: qsTr("Search sample by identifiant or vcf filename, subject's name, identifier, comment, ...")
                        onTextEdited: regovar.samplesManager.proxy.setFilterString(text)
                    }

                    TableView
                    {
                        id: selectedSamplesTable
                        Layout.fillHeight: true
                        Layout.fillWidth: true


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
                                        if (styleData.value.status === 1) // 1 = Loading
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
                                        duration: 1500
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
                                text: qsTr("No sample complient with the selected reference ") + regovar.analysesManager.newFiltering.refName + qsTr(" on the server Regovar.\nTo import new samples from files click on the button below.")
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


                Button
                {
                    id: importSampleButton
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal * 2

                    text: qsTr("Import samples\nfrom files")
                    onClicked:
                    {
                        filesSelector.open();
                    }
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
                // OK Clicked from "sample selection" view: import selected
                if (!sampleDialog.importingFile)
                {
                    selectedSamplesTable.selection.forEach( function(rowIndex)
                    {
                        var idx = regovar.samplesManager.proxy.getModelIndex(rowIndex);
                        var id = regovar.samplesManager.data(idx, 257); // 257 = Qt::UserRole+1
                        samples = samples.concat(regovar.samplesManager.getOrCreateSample(id));
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





    SelectFilesDialog
    {
        id: filesSelector
        searchQuery: "vcf"
        title: "Select file(s) to import as sample"
        onFileSelected:
        {
            var filesIds = [];
            var filesReady = true;
            for(var idx in files)
            {
                var file = files[idx];
                if (file.status !== "uploaded" && file.status !== "checked") filesReady = false;
                filesIds.append(file.id);
            }

            if (!filesReady)
            {
                // alert
                infoDialog.open();
            }
            else
            {
                // Import files
                for(var fid in files)
                {
                    regovar.samplesManager.importFromFile(fid, regovar.samplesManager.referencialId, filteringAnalysis, subject);
                }
            }
        }
    }

    InfoDialog
    {
        id: infoDialog
        text: qsTr("Some of selected files cannot be import. Please wait untill all files upload complete before trying to import them.")
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


