import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework/FileViewers"

Rectangle
{
    color: "transparent"
    clip: true


    function openFile(id)
    {
        waitingPanel.visible = true;
        emptyPanel.visible = false;

        // Get file
        var file = regovar.filesManager.getOrCreateFile(id);

        // Check online status
        switch(file.status)
        {
        case 0: // Uploading
            waitingPanel.visible = true;
            waitingPanel.model = file;
            return;

        case 3: // error
            errorPanel.visible = true;
            errorPanel.model = file;
            return;
        }

        // Check if already in cache
        if (file.localFileReady)
        {
            // yes : open it
            viewer.visible = true;
            buildViewer(file)
        }
        else
        {
            // no : download it
            waitingPanel.visible = true;
            waitingPanel.model = file;
            file.downloadLocalFile();
            return;
        }
    }

    function buildViewer(file)
    {
        // Find viewer according to file extension
        var qmlPage = file.getQMLViewer();

        // Setup qml viewer and display it
        var comp = Qt.createComponent("FileViewers/" + qmlPage);
        if (comp.status == Component.Ready)
        {
            var elmt = comp.createObject(viewer);
            if (elmt.hasOwnProperty("model"))
            {
                elmt.model = file;
            }
            console.log ("load file viewer: " + qmlPage)
        }
        else if (comp.status == Component.Error)
        {
            console.log("Error loading component: ", comp.errorString());
        }
    }

    Item
    {
        id: rightPanel
        anchors.fill: parent
        anchors.leftMargin: 10

        Rectangle
        {
            id: emptyPanel
            anchors.fill: parent
            color: "transparent"

            Text
            {
                anchors.centerIn: parent
                text: qsTr("Select a document")
                font.pixelSize: Regovar.theme.font.size.title
                color: Regovar.theme.primaryColor.back.light
            }
        }

        WaitingPanel
        {
            id: waitingPanel
            anchors.fill: parent
            color: Regovar.theme.backgroundColor.main
            visible: false
            onWaitingDone: openFile(fileId)
        }

        Item
        {
            id: viewer
            anchors.fill: parent
        }
    }
}
