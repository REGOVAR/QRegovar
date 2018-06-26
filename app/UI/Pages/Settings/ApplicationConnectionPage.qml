import QtQuick 2.9
import QtQuick.Layouts 1.3


import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model
    property bool ready: false

    Component.onCompleted:
    {
        regovarUrl.text = regovar.networkManager.serverUrl;
        sharedUrl.text = regovar.networkManager.sharedUrl;

        regovar.networkManager.testServerUrl(regovarUrl.text, sharedUrl.text);
        ready = true;
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
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Connection settings")
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

        // Proxy URL
        Text
        {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            height: Regovar.theme.font.boxSize.title
            elide: Text.ElideRight
            text: qsTr("Proxy")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        ComboBox
        {
            id: regovarProxyMode
            Layout.fillWidth: true
            width: parent.width
            model: [qsTr("No proxy"), qsTr("System configuration"), qsTr("Custom settings")]
        }


        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        TextField
        {
            id: regovarProxyUrl
            Layout.fillWidth: true
            width: parent.width
            placeholder: qsTr("http://proxy.regovar.com")
            onTextChanged:
            {
                regovarUrl.iconLeft = "m";
                regovarUrl.color = Regovar.theme.frontColor.warning;
            }
        }

        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        TextField
        {
            id: regovarProxyPort
            Layout.fillWidth: true
            width: parent.width
            placeholder: qsTr("Port")
            onTextChanged:
            {
                regovarUrl.iconLeft = "m";
                regovarUrl.color = Regovar.theme.frontColor.warning;
            }
        }




        // Server URL
        Text
        {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            height: Regovar.theme.font.boxSize.title
            elide: Text.ElideRight
            text: qsTr("Server")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }

        Text
        {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("The url to access to the Regovar server. If you change it, test the connection with the button \"Test connection\".")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }

        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        TextField
        {
            id: regovarUrl
            Layout.fillWidth: true
            width: parent.width
            placeholder: qsTr("http://regovar.local-site.com")
            onTextChanged:
            {
                regovarUrl.iconLeft = "m";
                regovarUrl.color = Regovar.theme.frontColor.warning;
            }
        }

        Item
        {
            Layout.columnSpan: 2
            width: 10
            height: 10
        }



        // Shared server URL
        Text
        {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title

            elide: Text.ElideRight
            text: qsTr("Shared server")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }

        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        Text
        {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("The url to access to the Shared Regovar server. If you change it, test the connection with the button \"Test connection\".")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }

        Item
        {
            Layout.minimumHeight: 10
            Layout.minimumWidth: Regovar.theme.font.boxSize.header
        }
        TextField
        {
            id: sharedUrl
            Layout.fillWidth: true
            width: parent.width
            placeholder: qsTr("http://regovar.shared-site.com")
            onTextChanged:
            {
                sharedUrl.iconLeft = "m";
                sharedUrl.color = Regovar.theme.frontColor.warning;
            }
        }




        // Connection test Button
        ButtonIcon
        {
            id: testConnectionButton
            Layout.columnSpan: 2
            text: qsTr("Test and apply changes !")
            iconTxt: "x"
            onClicked:
            {
                testConnectionButton.enabled = false;
                testConnectionButton.iconTxt = "/";
                regovar.networkManager.testServerUrl(regovarUrl.text, sharedUrl.text);
            }

            Connections
            {
                target: regovar.networkManager
                onTestServerUrlDone:
                {
                    regovarUrl.text = serverUrlValid;
                    regovarUrl.iconLeft = true ? "n" : "h";
                    regovarUrl.color = true ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.danger;

                    sharedUrl.text = sharedUrlValid;
                    sharedUrl.iconLeft = false ? "n" : "h";
                    sharedUrl.color = false ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.danger;

                    testConnectionButton.enabled = true;
                    testConnectionButton.iconTxt = "x";

                    if (root.ready && success && regovar.loaded)
                    {
                        checkInfo.open();
                    }
                }
            }
        }


        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    InfoDialog
    {
        id: checkInfo
        title: qsTr("Connection settings updated")
        text: qsTr("Servers urls have been changed. The application will restart to apply changes.")
        onOk: regovar.restart()
    }
}
