import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border

    width: 300
    height: 100

    property File fileModel: null
    property Sample sampleModel: null
    property var samplesNames: []
    property double progress: 0

    property var model
    onModelChanged: refreshModel()


    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        RowLayout
        {
            spacing: 5
            Text
            {

                Layout.fillWidth: true
                text: fileModel.name
            }
            ButtonInline
            {
                property bool paused: false
                onPausedChanged:
                {
                    if (paused)
                        regovar.filesManager.pauseUpload(fileModel.id);
                    else
                        regovar.filesManager.startUpload(fileModel.id);
                }

                text: ""
                icon: paused ? "x" : "y"
                onClicked: paused = !paused
            }
            ButtonInline
            {
                text: ""
                icon: "h"
                onClicked:
                {
                    regovar.filesManager.cancelUpload(fileModel.id);
                    model["canceled"] = true;
                    root.enabled = false;
                }
            }
        }
        GridLayout
        {
            rowSpacing: 5
            columnSpacing: 10
            columns: 2

            Text
            {
                text: "File upload:"
            }
            ProgressBar
            {
                id: fileUploadProgress
                Layout.fillWidth: true
                value: 0
            }
            Text
            {
                text: "Sample import:"
            }
            ProgressBar
            {
                id: sampleImportProgress
                Layout.fillWidth: true
                value: 0
            }
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
                if (sample.source === fileModel)
                {

                    if (sampleModel === null)
                    {
                        sampleModel = sample;
                        sampleModel.dataChanged.connect(updateSampleProgress);
                    }
                    if (!(sample in model["samples"]))
                    {
                        model["samples"].push(sample);
                        samplesNames.push(sample.name);
                    }
                }
            }
        }
    }



    function refreshModel()
    {
        if (model)
        {
            // Disconnect former models
            if (fileModel && fileModel !== model["file"])
            {
                fileModel.dataChanged.disconnect(updateFileProgress);
                fileModel = null;
            }
            if (sampleModel && model["samples"].length > 0 && sampleModel !== model["samples"][0])
            {
                // disconnect former model
                sampleModel.dataChanged.disconnect(updateSampleProgress);
                sampleModel = null;
            }

            root.enabled = !model["canceled"];
            fileUploadProgress.to = model["fileProgressTo"];
            fileUploadProgress.value = model["fileProgressValue"];
            sampleImportProgress.value = model["sampleProgress"];

            if (fileModel === null)
            {
                fileModel = model["file"];
                fileModel.dataChanged.connect(updateFileProgress);
            }
            if (sampleModel === null && model["samples"].length > 0)
            {
                sampleModel = model["samples"][0];
                sampleModel.dataChanged.connect(updateSampleProgress);


                var names = [];
                for (var k in model["samples"])
                {
                    var sample = model["samples"][k];
                    names.push(sample.name);
                }
            }
        }
    }

    function updateFileProgress()
    {
        fileUploadProgress.to = fileModel.size;
        fileUploadProgress.value = fileModel.uploadOffset;
        model["fileProgressTo"] = fileModel.size;
        model["fileProgressValue"] = fileModel.uploadOffset;
    }
    function updateSampleProgress()
    {
        sampleImportProgress.value = sampleModel.loadingProgress;
        model["sampleProgress"] = sampleModel.loadingProgress;
    }
}
