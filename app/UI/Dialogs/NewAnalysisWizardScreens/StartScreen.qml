import QtQuick 2.7
import QtQuick.Layouts 1.3

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    signal selected(var choice)

    Text
    {
        id: startScreenTip
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        text: qsTr("Select above what you want to do.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.control
        color: Regovar.theme.frontColor.normal
    }

    RowLayout
    {
        anchors.top: startScreenTip.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Button
        {
            text : "Analyse a file"
            onClicked: selected(1);
            Layout.alignment : Qt.AlignHCenter
        }
        Button
        {
            text : "Run a pipeline"
            onClicked: selected(2);
            Layout.alignment : Qt.AlignHCenter
        }
        Button
        {
            text : "Filtering variant"
            onClicked: selected(3);
            Layout.alignment : Qt.AlignHCenter
        }
    }
}
