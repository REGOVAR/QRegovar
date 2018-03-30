import QtQuick 2.9
import QtQuick.Layouts 1.3


import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model


    Component.onCompleted:
    {
        regovarUrl.text = regovar.networkManager.serverUrl;
        sharedUrl.text = regovar.networkManager.sharedUrl;

        regovar.networkManager.testServerUrl(regovarUrl.text, sharedUrl.text);
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
            text: qsTr("Connection settings")
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

        // Server URL
        Text
        {
            Layout.fillWidth: true
            Layout.row: 0
            Layout.column: 0
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
            text: qsTr("The url to access to the Regovar server. If you change it, test the connection with the button \"Test connection\".")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        TextField
        {
            id: regovarUrl
            Layout.row: 2
            Layout.column: 1
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
            Layout.row: 3
            Layout.column: 0
            width: 10
            height: 10
        }



        // Shared server URL
        Text
        {
            Layout.row: 4
            Layout.column: 0
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
        Text
        {
            Layout.row: 5
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: qsTr("The url to access to the Shared Regovar server. If you change it, test the connection with the button \"Test connection\".")
            font.pixelSize: Regovar.theme.font.size.normal
            color: Regovar.theme.primaryColor.back.normal
            height: Regovar.theme.font.boxSize.normal
            verticalAlignment: Text.AlignVCenter
        }
        TextField
        {
            id: sharedUrl
            Layout.row: 6
            Layout.column: 1
            Layout.fillWidth: true
            width: parent.width
            placeholder: qsTr("http://regovar.shared-site.com")
            onTextChanged:
            {
                sharedUrl.iconLeft = "m";
                sharedUrl.color = Regovar.theme.frontColor.warning;
            }
        }

        Item
        {
            Layout.row: 7
            Layout.column: 0
            width: 10
            height: 10
        }




        // Connection test Button
        ButtonIcon
        {
            id: testConnectionButton
            Layout.row: 8
            Layout.column: 0
            Layout.columnSpan: 2
            text: qsTr("Test connection !")
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
                    var test1 = serverUrlValid == regovarUrl.text;
                    regovarUrl.iconLeft = test1 ? "n" : "h";
                    regovarUrl.color = test1 ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.danger;

                    var test2 = sharedUrlValid == sharedUrl.text;
                    sharedUrl.iconLeft = test2 ? "n" : "h";
                    sharedUrl.color = test2 ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.danger;

                    testConnectionButton.enabled = true;
                    testConnectionButton.iconTxt = "x";
                }
            }
        }


        Item
        {
            Layout.row: 9
            Layout.column: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
