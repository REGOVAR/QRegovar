import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import org.regovar 1.0

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    // List of file's paths selected by the fileDialog to allow us
    // to map with uploding file when enqueued signal is raised by the model
    property var fileUploadList: []
    // List of file id of file which uploaded is done and for which we had start the
    // Sample import
    property var sampleImportStarted: []
    // List of file that are uploading and
    property var model: []

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("This page allow you to start and monitore the import of new samples from local file.")
    }

    ColumnLayout
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        spacing: 10

        Text
        {
            Layout.fillWidth: true
            text: "Import in progress"
        }

        ScrollView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                spacing: 5

                Repeater
                {
                    id: importRepeater

                    SampleFileImportControl
                    {
                        model: modelData
                    }
                }
            }
        }

        ButtonIcon
        {
            text: "Import additional sample from files"
            onClicked: filesDialog.open()
        }
    }

    FileDialog
    {
        id: filesDialog
        nameFilters: [ "VCF files (*.vcf *.vcf.gz)", "GVCF (*.gvcf *.gvcf.gz)", "All files (*)" ]
        selectedNameFilter: "VCF files (*.vcf *.vcf.gz)"
        title: "Select file(s) to upload on the server"
        //folder: shortcuts.home
        selectMultiple: true

        onAccepted: importFiles(filesDialog.fileUrls)
    }




    function getImportedSamples()
    {
        for (var k1 in root.model)
        {
            var itemModel = root.model[k1];
            if (file == itemModel["sample"])
            {
                totalOffset += file.uploadOffset;
                totalSize += file.size;

                if (file.loaded && file.uploadOffset == file.size && !itemModel["sampleImportCalled"])
                {
                    itemModel["sampleImportCalled"] = true;
                    regovar.analysesManager.newFiltering.addSamplesFromFile(file.id);
                }
            }
        }
    }

    function importFiles(files)
    {
        console.log("Start upload of sample's files : " + files);
        var filesToImport = [];
        for (var idx=0; idx<files.length; idx++)
        {
            var file = files[idx];
            if (file.startsWith("file:///"))
            {
                file = file.substr(8);
            }

            if (file in fileUploadList) continue;
            filesToImport.push(file);
            root.fileUploadList.push(file);
        }

        // Enqueue file to the TUS upload manager.
        // When upload will start, the fileManager will emit uploadsChanged signal
        // We will be able to retrieve created File & Sample entries in the model
        // and update the view accordingly (see connection below)
        regovar.filesManager.enqueueUploadFile(filesToImport);
    }

    // On Model signal : Add to the view file that we are uploading
    Connections
    {
        target: regovar.filesManager
        onFileUploadEnqueued:
        {
            if (!(localPath in fileUploadList))
            {
                var itemModel = {"file": regovar.filesManager.getOrCreate(fileId), "samples": [], "sampleImportCalled": false, "canceled": false};
                itemModel["file"].load();
                root.model.push(itemModel);

                importRepeater.model = root.model;
            }
        }
    }

    // On Upload progress update: check if upload 100% then start sample import
    Connections
    {
        target: regovar.filesManager
        onUploadsChanged:
        {
            // Get progress for all files currently uploading,
            // + compute global progress for all uploads
            // + start sample import for each file uploaded
            var totalOffset = 0;
            var totalSize = 0;
            for (var k1 in regovar.filesManager.uploadsList)
            {
                var file = regovar.filesManager.uploadsList[k1];
                for (var k2 in root.model)
                {
                    var itemModel = root.model[k2];
                    if (file == itemModel["file"])
                    {
                        totalOffset += file.uploadOffset;
                        totalSize += file.size;

                        if (file.loaded && file.uploadOffset == file.size && !itemModel["sampleImportCalled"])
                        {
                            itemModel["sampleImportCalled"] = true;
                            regovar.analysesManager.newFiltering.addSamplesFromFile(file.id);
                        }
                    }
                }
            }
            console.log("upload progress : " + totalOffset + "/" + totalSize + " (" + (totalOffset/totalSize*100).toFixed(1) + "%")
        }
    }


    // Retrieve which samples have been imported from uploaded files.
    Connections
    {
        target: regovar.analysesManager.newFiltering
        onSamplesChanged:
        {
            for (var k1 in regovar.analysesManager.newFiltering.samples)
            {
                var sample = regovar.analysesManager.newFiltering.samples[k1];
                for (var k2 in root.model)
                {
                    var itemModel = root.model[k2];
                    if (itemModel["file"] == sample["source"])
                    {
                        if (!(sample in itemModel["samples"]))
                        {
                            itemModel["samples"].push(sample);
                        }
                    }
                }
            }
        }
    }
}
