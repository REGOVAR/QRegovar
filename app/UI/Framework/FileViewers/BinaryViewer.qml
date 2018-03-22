import QtQuick 2.9
import QtQuick.Controls 2.2
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

        Text
        {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("This file cannot be open with Regovar.")
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
        Button
        {
            text: qsTr("Open it with an external tool.")
            onClicked: Qt.openUrlExternally(model.localFilePath);
            enabled: model.localFileReady
        }
    }
}
