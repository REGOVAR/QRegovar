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


    Rectangle
    {
        id: panel

        width: 400
        height: 200
        radius: 2
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        color: Regovar.theme.boxColor.back


        anchors.centerIn: parent


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
                Keys.onPressed: { if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) tryLogin(); }
            }

            TextField
            {
                id: pwdField
                Layout.fillWidth: true
                placeholder: qsTr("Password")
                echoMode: TextInput.Password
                //onTextEdited: regovar.usersManager.login(loginField.text, pwdField.text);
                Keys.onPressed: { if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) tryLogin(); }
            }

            RowLayout
            {
                CheckBox
                {
                    Layout.fillWidth: true
                    text: qsTr("Keep me logged in")
                    checked: regovar.usersManager.keepMeLogged
                    onCheckedChanged: regovar.usersManager.keepMeLogged = checked
                    Keys.onPressed: { if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) tryLogin(); }
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
        anchors.top: panel.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: panel.horizontalCenter
        text: qsTr("If you have lost your credentials, contact your admin")  // TODO: qsTr("I forgot my credential")
        color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.frontColor.normal
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
