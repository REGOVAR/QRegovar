import QtQuick 2.9
import QtQuick.Layouts 1.3


import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model

    Component.onCompleted:
    {

        referenceCombo.currentIndex = regovar.settings.defaultReference - 1; // 0 is for All
        pubmedField.text = regovar.settings.pubmedTerms;
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            text: qsTr("Regovar settings")
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("Regovar application settings. Note that your settings are saved on this computer only. You will need to restart the application to apply your settings.")
    }


    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        rowSpacing: 10
        columns:2

        // Default reference
        Text
        {
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header

            elide: Text.ElideRight
            text: qsTr("Default reference")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Rectangle
        {
            Layout.row: 1
            Layout.column: 0
            color: "transparent"
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        Text
        {
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            anchors.leftMargin: Regovar.theme.font.boxSize.title
            text: qsTr("Select the reference you want to use by default when you create filtering analysis or import new sample file.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        ComboBox
        {
            id: referenceCombo
            Layout.row: 2
            Layout.column: 1
            Layout.fillWidth: true
            anchors.leftMargin: Regovar.theme.font.boxSize.title
            model: regovar.references
            textRole: "name"
            onCurrentIndexChanged:
            {
                regovar.settings.defaultReference = currentIndex;
                regovar.settings.save();
            }
        }

        Rectangle
        {
            Layout.row: 3
            Layout.column: 0
            color: "transparent"
            width: 10
            height: 10
        }

        // Default pubmed searched terms
        Text
        {
            Layout.row: 4
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Pubmed searched terms")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Text
        {
            Layout.row: 5
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("Set terms (separeted by comma) that you want beeing automatically searched associated with the gene name. You can see these information when opening the information popup of a gene.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        TextField
        {
            id: pubmedField
            Layout.row: 6
            Layout.column: 1
            Layout.fillWidth: true
            placeholder: qsTr("autism, RNAseq, BIRC6 ...")
            onTextChanged:
            {
                regovar.settings.pubmedTerms = text;
                regovar.settings.save();
            }
        }

        Rectangle
        {
            Layout.row: 7
            Layout.column: 0
            color: "transparent"
            width: 10
            height: 10
        }

        // Subject indicators
        Text
        {
            Layout.row: 8
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Subject indicators")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Text
        {
            Layout.row: 9
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("Set custom indicators to help you to manage subjects. Indicators are set for all subjects stored on this server, and are shared with all users.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle
        {
            Layout.row: 10
            Layout.column: 1
            color: "transparent"
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.normal
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            Text
            {
                anchors.centerIn: parent
                text: qsTr("Not yet implemented")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle
        {
            Layout.row: 11
            Layout.column: 0
            color: "transparent"
            width: 10
            height: 10
        }

        // Analyses indicators
        Text
        {
            Layout.row: 12
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Analyses indicators")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Text
        {
            Layout.row: 13
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("Set custom indicators to help you to manage analyses. Indicators are set for all analyses done on this server, and are shared with all users.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle
        {
            Layout.row: 14
            Layout.column: 1
            color: "transparent"
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.normal
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            Text
            {
                anchors.centerIn: parent
                text: qsTr("Not yet implemented")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.disable
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle
        {
            Layout.row: 15
            Layout.column: 1
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
