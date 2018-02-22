import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.boxColor.back
    border.width: 1
    border.color: Regovar.theme.boxColor.border

    width: parent.width
    height: 100

    property File fileModel: null
    onFileModelChanged:
    {
        if (fileModel)
        {
            fileModel.dataChanged.connect(updateFileProgress);
        }
    }
    Component.onDestruction:
    {
        fileModel.dataChanged.disconnect(updateFileProgress);
    }

    property double progress: 0
    property bool sampleImportAsked: false
    property Sample sampleModel: null
    property var samplesNames: []




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
                text: fileModel ? fileModel.name : ""
                elide: Text.ElideRight
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
                iconTxt: paused ? "x" : "y"
                onClicked: paused = !paused
            }
            ButtonInline
            {
                text: ""
                iconTxt: "h"
                onClicked:
                {
                    regovar.filesManager.cancelUpload(fileModel.id);
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
        target: regovar.samplesManager
        onSampleImportStart:
        {
            if (fileModel && fileId == fileModel.id)
            {
                if (samplesIds.length == 0)
                {
                    // TODO: no sample found in the file. no import done
                }
                else
                {
                    // Get first sample as ref to be notified of import progress
                    sampleModel = regovar.samplesManager.getOrCreate(samplesIds[0]);
                    sampleModel.dataChanged.connect(updateSampleProgress);
                }
            }
        }
    }

    function updateFileProgress()
    {
        if (fileModel)
        {
            fileUploadProgress.to = fileModel.size;
            fileUploadProgress.value = fileModel.uploadOffset;

            // Check if need to start sample import
            if (!sampleImportAsked && fileModel.size !=0 && fileModel.size == fileModel.uploadOffset)
            {
                sampleImportAsked = true;
                regovar.analysesManager.newFiltering.addSamplesFromFile(fileModel.id);
            }
        }
    }

    function updateSampleProgress()
    {
        if (sampleModel)
        {
            sampleImportProgress.value = sampleModel.loadingProgress;
        }
    }

    function clear()
    {
        console.log("clear SampleFileImportControl")
        if (fileModel)
        {
            console.log(" > fileModel");
            fileModel.dataChanged.disconnect(updateFileProgress);
        }
        if (sampleModel)
        {
            console.log(" > samplemodel");
            sampleModel.dataChanged.disconnect(updateSampleProgress);
        }
    }
}
