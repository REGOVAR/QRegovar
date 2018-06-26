import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2


import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model


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
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Interface settings")
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

        // Language
        Text
        {
            Layout.fillWidth: true
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 2
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Language")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Item
        {
            Layout.row: 1
            Layout.column: 0
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        Text
        {
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("Select the language of the Regovar application.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        ComboBox
        {
            Layout.row: 2
            Layout.column: 1
            Layout.fillWidth: true
            width: parent.width
            model: [qsTr("English")]
            currentIndex: 0
            enabled: false
        }

        Item
        {
            Layout.row: 3
            Layout.column: 0
            width: 10
            height: 10
        }


        // Theme
        Text
        {
            Layout.row: 4
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Theme")
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
            text: qsTr("Select the color theme of the Regovar application.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        ComboBox
        {
            Layout.row: 6
            Layout.column: 1
            Layout.fillWidth: true
            width: parent.width
            model: ["Regovar light", "Regovar dark", "Halloween"]
            currentIndex: Regovar.theme.themeId
            onCurrentIndexChanged: Regovar.theme.themeId = currentIndex
        }

        Item
        {
            Layout.row: 7
            Layout.column: 0
            width: 10
            height: 10
        }





        // Font size
        Text
        {
            Layout.row: 8
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Font size")
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
            text: qsTr("Adapt the size of the text to the size and resolution of your screen.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        Button
        {
            Layout.row: 10
            Layout.column: 1
            text: qsTr("Set size")
            onClicked: setSizePopup.open()
        }

        Item
        {
            Layout.row: 11
            Layout.column: 0
            width: 10
            height: 10
        }

        // Help
        Text
        {
            Layout.row: 12
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Help boxes")
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
            text: qsTr("Display or hide help and information boxes in the application.")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        CheckBox
        {
            Layout.row: 14
            Layout.column: 1
            Layout.fillWidth: true
            text: qsTr("Display help boxes")
            checked: Regovar.helpInfoBoxDisplayed
            onCheckedChanged: Regovar.helpInfoBoxDisplayed = checked
        }

        Item
        {
            Layout.row: 15
            Layout.column: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    Dialog
    {
        id: setSizePopup
        width: 250
        height: 100
        Rectangle
        {
            color: "transparent"
            width: 200
            height: Regovar.theme.font.boxSize.normal

            Rectangle
            {
                color: Regovar.theme.primaryColor.back.normal
                width: 2
                height: parent.height
                x: Math.round(5 * (200 / 15.0))
            }

            Slider
            {
                maximumValue: 2
                minimumValue: 0.5
                stepSize: 0.1
                value: Regovar.theme.fontSizeCoeff
                onValueChanged: Regovar.theme.fontSizeCoeff = value
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
