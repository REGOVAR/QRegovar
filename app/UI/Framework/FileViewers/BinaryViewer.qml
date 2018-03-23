import QtQuick 2.9
import QtQuick.Controls 2.2
import Regovar.Core 1.0

import "../../Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main
    anchors.fill: parent

    property File model

    Text
    {
        id: message
        anchors.centerIn: parent
        text: qsTr("This file cannot be open with Regovar.")
        font.pixelSize: Regovar.theme.font.size.title
        color: Regovar.theme.primaryColor.back.light
    }
    Button
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: message.bottom
        anchors.topMargin: 10
        text: qsTr("Open it with an external tool.")
        onClicked: Qt.openUrlExternally("file://" + model.localFilePath);
    }
}
