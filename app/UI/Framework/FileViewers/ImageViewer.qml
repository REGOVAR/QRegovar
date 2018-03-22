import QtQuick 2.9
import Regovar.Core 1.0

import "../../Regovar"

Rectangle
{
    id: root
    color: "transparent"

    property File model

    Column
    {
        anchors.centerIn: parent
        spacing: 10


        Image
        {
            id: imageViewer
            anchors.fill: parent
            source: model.localFilePath
        }
    }
}
