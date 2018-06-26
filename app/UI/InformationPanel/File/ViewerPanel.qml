import QtQuick 2.9

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property alias model: viewer.model

    FileViewer
    {
        id: viewer
        anchors.fill: parent
        anchors.topMargin: 10
    }
}
