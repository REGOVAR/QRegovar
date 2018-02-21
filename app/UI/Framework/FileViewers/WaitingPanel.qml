import QtQuick 2.9
import QtQuick.Controls 2.2
import Regovar.Core 1.0

import "../../Regovar"

Rectangle
{
    id: root
    color: "transparent"

    signal waitingDone(int fileId)
    property File file
    onFileChanged:
    {
        file.localFileReadyChanged.connect(waitingDoneHandler);
        msg.text = qsTr("The document {0} is uploading...").replace("{0}", file.name);
    }
    Component.onDestruction:
    {
        if (file)
        {
            file.localFileReadyChanged.disconnect(waitingDoneHandler);
        }
    }


    Text
    {
        id: msg
        anchors.centerIn: parent
        text: "Waiting..."
        font.pixelSize: Regovar.theme.font.size.title
        color: Regovar.theme.primaryColor.back.light
    }

    function waitingDoneHandler()
    {
        file.localFileReadyChanged.disconnect(waitingDoneHandler);
        root.waitingDone(file.id);
    }
}
