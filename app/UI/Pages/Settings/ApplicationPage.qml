import QtQuick 2.7
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
        // init fields
        regovarUrl.text = regovar.networkManager.serverUrl;
        sharedServerUrl.text = regovar.networkManager.sharedServerUrl;

        cacheDir.text = regovar.filesManager.cacheDir;
        cacheMaxSize.value = regovar.filesManager.cacheMaxSize;
        var current = regovar.filesManager.cacheSize;
        cacheCurrentSize.text = regovar.sizeToHumanReadable(current, current);

        regovar.networkManager.testServerUrl(regovarUrl.text);
        regovar.networkManager.testServerUrl(sharedServerUrl.text);
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
                onTextChanged:
                {
                    regovarUrl.iconLeft = "m";
                    regovarUrl.color = Regovar.theme.frontColor.warning;
                }
            }
            Text
            {
                id: regovarUrlMsg
                width: parent.width
                text: qsTr("The url to access to the Regovar server. If you change it, test the connection with the button \"Test connection\".")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Connection test Button
        ButtonIcon
        {
            id: testConnectionButton
            Layout.rowSpan: 2
            Layout.alignment: Qt.AlignTop
            text: qsTr("Test connection !")
            icon: "x"
            onClicked:
            {
                testConnectionButton.enabled = false;
                testConnectionButton.icon = "/";
                regovar.networkManager.testServerUrl(regovarUrl.text);
                regovar.networkManager.testServerUrl(sharedServerUrl.text);
            }

            Connections
            {
                target: regovar.networkManager
                onTestServerUrlDone:
                {
                    var icon = success ? "n" : "h";
                    var color = success ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.danger;
                    var message = success ? qsTr("Url is valid.") : qsTr("The provided url is not valid.")

                    if (url == regovarUrl.text)
                    {
                        regovarUrl.iconLeft = icon;
                        regovarUrl.color = color;
                        regovarUrlMsg.text = message;
                    }
                    else
                    {
                        sharedServerUrl.iconLeft = icon;
                        sharedServerUrl.color = color;
                        sharedServerUrlMsg.text = message;
                    }
                    testConnectionButton.enabled = true;
                    testConnectionButton.icon = "x";
                }
            }
        }


        // Shared server URL
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
                text: qsTr("Shared server")
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
                id: sharedServerUrl
                width: parent.width
                placeholderText: qsTr("http://regovar.shared-site.com")
                onTextChanged:
                {
                    sharedServerUrl.iconLeft = "m";
                    sharedServerUrl.color = Regovar.theme.frontColor.warning;
                }
            }
            Text
            {
                id: sharedServerUrlMsg
                width: parent.width
                text: qsTr("The url to access to the Shared Regovar server. If you change it, test the connection with the button \"Test connection\".")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }



        // ===== Local cache Section =====
        Row
        {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            height: Regovar.theme.font.boxSize.title

            Text
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                text: "1"

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
                text: qsTr("Local files cache")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }

        // Cache location
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
                text: qsTr("Cache directory")
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
                id: cacheDir
                width: parent.width
                placeholderText: qsTr("Let empty to use default OS application cache directory")
            }
            Text
            {
                id: cacheDirMsg
                width: parent.width
                text: qsTr("The folder on this computer where file will be downloaded.")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Action buttons
        Column
        {
            ButtonIcon
            {
                Layout.rowSpan: 2
                Layout.alignment: Qt.AlignTop
                text: qsTr("Clear cache !")
                icon: "h"
                onClicked:
                {
                    regovar.filesManager.clearCache();
                }
            }
            Text
            {
                id: cacheCurrentSize
            }
        }

        // Cache size limit
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
                text: qsTr("Size limit")
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

            Row
            {
                spacing: 10

                Rectangle
                {
                    color: "transparent"
                    width: 400
                    height: Regovar.theme.font.boxSize.normal

                    Rectangle
                    {
                        color: Regovar.theme.primaryColor.back.normal
                        width: 2
                        height: parent.height
                        x: Math.round(100 * (parent.width / cacheMaxSize.maximumValue)) + 5
                    }

                    Slider
                    {
                        id: cacheMaxSize
                        maximumValue: 1000
                        minimumValue: 1
                        stepSize: 1
                        value: 0
                        onValueChanged:
                        {
                            cacheMaxSizeLabel.text = value + " Go";
                            regovar.filesManager.cacheMaxSize = value;
                        }
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text
                {
                    id: cacheMaxSizeLabel
                    text: ""
                }
            }

            Text
            {
                width: parent.width
                text: qsTr("Set the maximum size allowed for the cache folder (Older cached files will be automatically deleted when folder size limit is reach.")
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

        // No action buttons
        Item
        {
            Layout.minimumWidth: 10
            Layout.minimumHeight: 10
            Layout.rowSpan: 4
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
