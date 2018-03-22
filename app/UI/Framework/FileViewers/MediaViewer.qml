import QtQuick 2.9
import QtMultimedia 5.9
import Regovar.Core 1.0

import "../../Regovar"

Rectangle
{
    id: root
    color: "transparent"

    property File model
    onModelChanged:
    {
        if (model)
        {
            mediaplayer.source = model.localFilePath;
        }
    }

    MediaPlayer
    {
        id: mediaplayer
        anchors.fill: parent
    }
}
