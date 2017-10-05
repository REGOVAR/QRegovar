import QtQuick 2.7
import QtQuick.Layouts 1.3


import "../../Regovar"
import "../../Framework"

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
            text: qsTr("Regovar application settings")
            font.pixelSize: 20
            font.weight: Font.Black
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

        columns: 2
        rows:10
        columnSpacing: 30
        rowSpacing: 20

        // Server URL
        Text
        {
            text: qsTr("Server")
            font.pixelSize: Regovar.theme.font.size.control
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.alignment: Qt.AlignTop
            height: Regovar.theme.font.boxSize.control
            verticalAlignment: Text.AlignVCenter
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5

            RowLayout
            {
                width: parent.width

                TextField
                {
                    id: regovarUrl
                    Layout.fillWidth: true
                    placeholderText: qsTr("http://regovar.local-site.com")
                    text: regovar.serverUrl
                }
                ButtonIcon
                {
                    id: testConnectionButton
                    text: qsTr("Test connection !")
                    icon: "x"
                    onClicked:
                    {
                        icon = "/";
                        regovar.testConnection(regovarUrl.text, proxyUrl.text);
                    }
                }
                Connections
                {
                    target: regovar
                    onTestConnectionEnd:
                    {
                        testConnectionButton.icon = "x";

                    }
                }

            }
            Text
            {
                width: parent.width
                text: qsTr("The url to access to the Regovar server. If you change it, test the connection with the button \"Test connection\".")
                font.pixelSize: Regovar.theme.font.size.content
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }

        }

        // Proxy URL
        Text
        {
            text: qsTr("Proxy")
            font.pixelSize: Regovar.theme.font.size.control
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.alignment: Qt.AlignTop
            height: Regovar.theme.font.boxSize.control
            verticalAlignment: Text.AlignVCenter
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5
            TextField
            {
                id: proxyUrl
                width: parent.width
                placeholderText: qsTr("http://regovar.local-site.com")
            }
            Text
            {
                width: parent.width
                text: qsTr("The url to the proxy. If you change it, test the connection with the button \"Test connection\".")
                font.pixelSize: Regovar.theme.font.size.content
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Language
        Text
        {
            text: qsTr("Language")
            font.pixelSize: Regovar.theme.font.size.control
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.alignment: Qt.AlignTop
            height: Regovar.theme.font.boxSize.control
            verticalAlignment: Text.AlignVCenter
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5
            ComboBox
            {
                width: parent.width
                model: [qsTr("English")]
                currentIndex: 0
                enabled: false
            }
            Text
            {
                width: parent.width
                text: qsTr("Select the language of the Regovar application.")
                font.pixelSize: Regovar.theme.font.size.content
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Theme
        Text
        {
            text: qsTr("Theme")
            font.pixelSize: Regovar.theme.font.size.control
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.alignment: Qt.AlignTop
            height: Regovar.theme.font.boxSize.control
            verticalAlignment: Text.AlignVCenter
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5
            ComboBox
            {
                width: parent.width
                model: ["Regovar light", "Regovar dark", "Halloween"]
                currentIndex: Regovar.theme.themeId
                onCurrentIndexChanged: Regovar.theme.themeId = currentIndex
            }
            Text
            {
                width: parent.width
                text: qsTr("Select the color theme of the Regovar application.")
                font.pixelSize: Regovar.theme.font.size.content
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Font size
        Text
        {
            text: qsTr("Font size")
            font.pixelSize: Regovar.theme.font.size.control
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.alignment: Qt.AlignTop
            height: Regovar.theme.font.boxSize.control
            verticalAlignment: Text.AlignVCenter
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5

            Rectangle
            {
                color: "transparent"
                width: 200
                height: Regovar.theme.font.boxSize.control

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

            Text
            {
                width: parent.width
                text: qsTr("Adapt the size of the text to the size and resolution of your screen.")
                font.pixelSize: Regovar.theme.font.size.content
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Help
        Text
        {
            text: qsTr("Help boxes")
            font.pixelSize: Regovar.theme.font.size.control
            font.bold: true
            color: Regovar.theme.primaryColor.back.normal
            Layout.alignment: Qt.AlignTop
            height: Regovar.theme.font.boxSize.control
            verticalAlignment: Text.AlignVCenter
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5

            CheckBox
            {
                text: qsTr("Display help boxes")
                checked: Regovar.helpInfoBoxDisplayed
                onCheckedChanged: Regovar.helpInfoBoxDisplayed = checked
            }
            Text
            {
                width: parent.width
                text: qsTr("Display or hide help and informations boxes in the application.")
                font.pixelSize: Regovar.theme.font.size.content
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        Rectangle
        {
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
