import QtQuick 2.9
import QtQuick.Layouts 1.3

import "qrc:/qml/Framework"
import "qrc:/qml/Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    onVisibleChanged:
    {
        if (visible)
        {
            loginField.text = "";
            pwdField.text = "";
            loginField.focus = true;
        }
    }

    function tryLogin()
    {
        regovar.usersManager.login(loginField.text, pwdField.text);
    }

    Logo
    {
        id: logo
        anchors.top: root.top
        anchors.topMargin: 100
        anchors.horizontalCenter: root.horizontalCenter
    }

    Column
    {
        anchors.top: logo.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: root.horizontalCenter
        width: 400
        spacing: 10



        Rectangle
        {
            id: serverPanel

            width: 400
            height: Regovar.theme.font.boxSize.title
            radius: 2
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            color: Regovar.theme.boxColor.back
            property bool editMode: false


            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 10

                Text
                {
                    id: serverStatusIcon
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.title
                    text: "n"

                    font.family: Regovar.theme.icons.name
                    font.pixelSize: Regovar.theme.font.size.title
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Regovar.theme.primaryColor.back.normal
                }


                Text
                {
                    id: serverStatusLabel
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    visible: !serverPanel.editMode
                }

                TextField
                {
                    id: serverStatusField
                    Layout.fillWidth: true
                    placeholder: qsTr("Serveur url")
                    visible: serverPanel.editMode
                }

                ButtonIcon
                {
                    id: serverStatusEdit
                    text: ""
                    iconTxt: "d"
                    visible: !serverPanel.editMode
                    onClicked:
                    {
                        serverPanel.editMode = true;
                    }
                }

                ButtonIcon
                {
                    id: serverStatusCancel
                    text: ""
                    iconTxt: "h"
                    visible: serverPanel.editMode
                    onClicked:
                    {
                        serverPanel.editMode = false;
                        serverStatusField.text = regovar.networkManager.serverUrl;
                    }
                }

                ButtonIcon
                {
                    id: serverStatusApply
                    text: ""
                    iconTxt: "5"
                    visible: serverPanel.editMode
                    onClicked:
                    {
                        serverPanel.editMode = false;
                        regovar.networkManager.testServerUrl(serverStatusField.text, regovar.networkManager.sharedUrl);
                        serverStatusField.text = regovar.networkManager.serverUrl;
                    }
                }
            }
        }


        Box
        {
            id: testServerWarning
            width: 400

            mainColor: regovar.config.welcomMessageType === "danger" ? Regovar.theme.frontColor.danger : regovar.config.welcomMessageType === "warning" ? Regovar.theme.frontColor.warning : Regovar.theme.frontColor.info;
            text: regovar.config.welcomMessage
            icon: regovar.config.welcomMessageType === "danger" ? "l" : regovar.config.welcomMessageType === "warning" ? "m" : "k";
            visible: regovar.config.welcomMessage !== ""
        }

        Rectangle
        {
            id: panel

            width: 400
            height: 200
            radius: 2
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            color: Regovar.theme.boxColor.back


            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: 50
                spacing: 10


                TextField
                {
                    id: loginField
                    Layout.fillWidth: true
                    placeholder: qsTr("Login")
                    focus: true
                    Keys.onPressed: { if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) tryLogin(); }
                }

                TextField
                {
                    id: pwdField
                    Layout.fillWidth: true
                    placeholder: qsTr("Password")
                    echoMode: TextInput.Password
                    //onTextEdited: regovar.usersManager.login(loginField.text, pwdField.text);
                    Keys.onPressed: { if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) tryLogin(); }
                }

                RowLayout
                {
                    CheckBox
                    {
                        Layout.fillWidth: true
                        text: qsTr("Keep me logged in")
                        checked: regovar.usersManager.keepMeLogged
                        //onCheckedChanged: regovar.usersManager.keepMeLogged = checked
                        Keys.onPressed: { if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) tryLogin(); }
                    }

                    Button
                    {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr("Go")
                        onClicked: tryLogin()
                    }
                }
            }
        }

        Text
        {
            text: qsTr("If you have lost your credentials, contact your admin")  // TODO: qsTr("I forgot my credential")
            color: Regovar.theme.frontColor.normal  // TODO: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
            horizontalAlignment: Text.AlignHCenter

            property bool hovered: false
            MouseArea
            {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: console.log("Shame on you !!")
            }
        }
    }


    Connections
    {
        target: regovar.networkManager
        onStatusChanged: updateConnectionStatus()
    }
    function updateConnectionStatus()
    {
        serverStatusField.text = regovar.networkManager.serverUrl;
        if (regovar.networkManager.status <= 1 ) // 0=ready, 1=access denied
        {
            serverStatusIcon.text = "n";
            serverStatusLabel.text = qsTr("Server is ready.");

            serverStatusIcon.color = Regovar.theme.frontColor.normal;
            serverStatusLabel.color = Regovar.theme.frontColor.normal;
        }
        else
        {
            serverStatusIcon.text = "l";
            serverStatusLabel.text = qsTr("Unable to connect the server.");

            serverStatusIcon.color = Regovar.theme.frontColor.danger;
            serverStatusLabel.color = Regovar.theme.frontColor.danger;
        }
    }
}
