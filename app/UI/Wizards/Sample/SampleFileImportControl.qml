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


    function refreshModel()
    {
        if (model)
        {
            if (fileModel === null)
            {
                root.fileModel = model["file"];
                root.fileModel.dataChanged.connect(function()
                {
                    fileUploadProgress.to = root.fileModel.size;
                    fileUploadProgress.value = root.fileModel.uploadOffset;
                });
            }
//            if (sampleModel === null && model["samples"].length > 0)
//            {
//                root.sampleModel = model["samples"][0];
//                root.progress = root.sampleModel.statusUI["progress"];
//                dataChanged
//                var names = [];
//                for (var k in model["samples"])
//                {
//                    var sample = model["samples"][k];
//                    names.push(sample.name);
//                }
//            }
        }
    }


    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 5
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
                text: "pause"
            }
            ButtonInline
            {
                text: "cancel"
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
                height: Regovar.theme.font.boxSize.normal
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
                height: Regovar.theme.font.boxSize.normal
                value: 0
            }
        }
    }

}
