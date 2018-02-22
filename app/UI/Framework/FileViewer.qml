import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0
import "../Regovar"
import "FileViewers"

Rectangle
{
    color: "transparent"
    clip: true


    function openFile(id)
    {
        emptyPanel.visible = true;
        waitingPanel.visible = true;
        viewer.visible = true;


        // Get file
        var file = regovar.filesManager.getOrCreateFile(id);

        // Check online status
        switch(file.status)
        {
        case 0: // Uploading
            waitingPanel.visible = true;
            waitingPanel.file = file;

            return;
        case 3: // error
            errorPanel.visible = true;
            errorPanel.file = file;
            return;
        }

        // Check if already in cache
        if (file.localFileReady)
        {
            // yes : open it
            viewer.visible = true;
            viewer.file = file;
        }
        else
        {
            // no : download it
            waitingPanel.visible = true;
            waitingPanel.file = file;
            file.downloadLocalFile();
            return;
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
                text: "Select a document"
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
        TxtViewer
        {
            id: viewer
            anchors.fill: parent
            visible: false
        }
    }
}
