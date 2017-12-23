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

    // FIXME: Workaround for Weird bug from QML ?
    // See connection on regovar.filesManager.onFileUploadEnqueued below
    property var fileUploadingList: []

    // List of file id of file which uploaded is done and for which we had start the
    // Sample import
    property var sampleImportStarted: []
    // List of file that are uploading and
    property var model: []

    Component.onDestruction:
    {
        // Clean connection with model
        console.log("Destroy SampleImportView : clear model connections")
        for (var elmt in importList)
        {
            elmt.clear();
        }
    }

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

    GridLayout
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        columns: 2
        rowSpacing: 10
        columnSpacing: 10


        Text
        {
            Layout.fillWidth: true
            text: qsTr("Import in progress")
        }

        Button
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Import samples\nfrom files")
            onClicked: filesDialog.open()
        }

        Rectangle
        {
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.margins: 10

            color: Regovar.theme.backgroundColor.alt
            border.width: 1
            border.color: Regovar.theme.boxColor.border


            ScrollView
            {
                id: importScrollView
                anchors.fill: parent
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                Column
                {
                    id: importList
                    x: 10
                    y: 10
                    width: importScrollView.width - 30
                    spacing: 5
                }
            }
        }

    }


    Component
    {
        id: importFileControl
        SampleFileImportControl {}
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





    function importFiles(files)
    {
        console.log("Start upload of sample's files : " + files);
        var filesToImport = [];

        // import only file that are not already importating
        for (var idx=0; idx<files.length; idx++)
        {
            var file = files[idx];
            if (file.startsWith("file:///"))
            {
                file = file.substr(8);
            }

            if (file in root.fileUploadingList) continue;
            filesToImport.push(file);
            root.fileUploadingList.push(file);
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
            // FIXME: This test is necessary as for a weird raison, QML connection is raised 2 times:
            // - one time with fileUploadingList as en empty object
            // - and one time with the fileUploadingList in the good states...
            // So to avoid to connect 2 times for a same file...
            if (root.fileUploadingList.indexOf(localPath) != -1)
            {
                // Create new file/sample  import control
                var elmt = importFileControl.createObject(importList, {"anchor.left": "parent.left", "anchor.right": "parent.right"});
                elmt.fileModel = regovar.filesManager.getOrCreate(fileId);
                elmt.fileModel.load();
            }
        }
    }
}
