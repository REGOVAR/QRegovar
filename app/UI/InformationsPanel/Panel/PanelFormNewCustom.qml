import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        rows: 6
        columns: 2
        columnSpacing: 30
        rowSpacing: 10


        Text
        {
            text: qsTr("Label")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: labelfield
            Layout.fillWidth: true
            placeholderText: qsTr("Optional label for the region.")
        }

        Text
        {
            text: qsTr("Reference*")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
            font.bold: true
        }
        ComboBox
        {
            id: refField
            Layout.fillWidth: true
            model: ["All", "hg19", "Hg38"]
        }

        Text
        {
            text: qsTr("Chr*")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
            font.bold: true
        }
        TextField
        {
            id: chrfield
            Layout.fillWidth: true
            placeholderText: qsTr("The number of the chromosome in the selected ref.")
        }

        Text
        {
            text: qsTr("Start*")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
            font.bold: true
        }
        TextField
        {
            id: startfield
            Layout.fillWidth: true
            placeholderText: qsTr("The start position of the region.")
        }

        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("End*")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
            font.bold: true
        }
        TextField
        {
            id: endfield
            Layout.fillWidth: true
            placeholderText: qsTr("The end position of the region.")
        }

        Item
        {
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    // Borders
    Rectangle
    {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1

        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1

        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1

        color: Regovar.theme.boxColor.border
    }
}
