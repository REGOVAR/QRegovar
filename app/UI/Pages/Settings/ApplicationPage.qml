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

        columns: 3
        rows: 10
        columnSpacing: 30
        rowSpacing: 20


        // ===== Connection Section =====
        Row
        {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            height: Regovar.theme.font.boxSize.title

            Text
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                text: "è"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.title
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                height: Regovar.theme.font.boxSize.title

                elide: Text.ElideRight
                text: qsTr("Connection")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }


        // Server URL
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                Layout.alignment: Qt.AlignTop
                text: qsTr("Server")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }

        }

        Column
        {
            Layout.fillWidth: true
            spacing: 5


            TextField
            {
                id: regovarUrl
                width: parent.width
                placeholderText: qsTr("http://regovar.local-site.com")
                text: regovar.serverUrl
            }
            Text
            {
                width: parent.width
                text: qsTr("The url to access to the Regovar server. If you change it, test the connection with the button \"Test connection\".")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Connection test panel
        Rectangle
        {
            Layout.rowSpan: 2
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            width: testConnectionButton.width + 20
            Layout.fillHeight: true


            ButtonIcon
            {
                id: testConnectionButton
                x:10
                y:10
                text: qsTr("Test connection !")
                icon: "x"
                onClicked:
                {
                    testConnectionButton.enabled = false;
                    testConnectionIcon.text = "/";
                    regovar.testConnection(regovarUrl.text, proxyUrl.text);
                }
//                Connections
//                {
//                    target: regovar
//                    onTestConnectionEnd:
//                    {
//                        testConnectionIcon.text = "n";
//                        testConnectionButton.enabled = true;

//                    }
//                }
            }
            Text
            {
                id: testConnectionIcon
                anchors.top: testConnectionButton.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: testConnectionLabel.top
                wrapMode: Text.WordWrap
                text: "n"
                verticalAlignment: Text.AlignVCenter
                font.family: Regovar.theme.icons.name
                font.pixelSize: 30
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                id: testConnectionLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                wrapMode: Text.WordWrap
                text: qsTr("Connection settings are OK")
                font.pixelSize: Regovar.theme.font.size.small
                color: Regovar.theme.primaryColor.back.normal
                horizontalAlignment: Text.AlignHCenter
            }

        }

        // Proxy URL
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                text: qsTr("Proxy")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                Layout.alignment: Qt.AlignTop
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
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
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }



        // ===== Interface Section =====
        Row
        {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            height: Regovar.theme.font.boxSize.title

            Text
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                text: "}"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.title
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                height: Regovar.theme.font.boxSize.title

                elide: Text.ElideRight
                text: qsTr("Interface")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }



        // Language
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                text: qsTr("Language")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                Layout.alignment: Qt.AlignTop
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
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
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Interface test panel
        Rectangle
        {
            Layout.rowSpan: 4
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            width: testConnectionButton.width + 20
            Layout.fillHeight: true

            ButtonIcon
            {
                x:10
                y:10
                text: qsTr("Apply settings")
                icon: "n"
            }
            Text
            {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                wrapMode: Text.WordWrap
                text: qsTr("Todo : preview of interface setting before validation")
                font.pixelSize: Regovar.theme.font.size.small
                color: Regovar.theme.primaryColor.back.normal
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Theme
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                text: qsTr("Theme")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                Layout.alignment: Qt.AlignTop
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
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
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Font size
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                text: qsTr("Font size")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                Layout.alignment: Qt.AlignTop
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
        }
        Column
        {
            Layout.fillWidth: true
            spacing: 5

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

            Text
            {
                width: parent.width
                text: qsTr("Adapt the size of the text to the size and resolution of your screen.")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Help
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                text: qsTr("Help boxes")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                Layout.alignment: Qt.AlignTop
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
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
                        font.pixelSize: Regovar.theme.font.size.small
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
