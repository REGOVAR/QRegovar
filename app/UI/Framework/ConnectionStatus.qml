import QtQuick 2.9
import QtQuick.Layouts 1.1

import "qrc:/qml/Regovar"


GridLayout
{
    id: root
    implicitWidth: 300
    property string userFullName: ""
    property string serverStatus: "online"
    property bool hovered: false

    rows:2
    columns: 2
    rowSpacing: 2
    columnSpacing: 10

    Text
    {
        id: userLabel
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.font.family
        color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.dark
        text:  hovered ? qsTr("Click to disconnect") : userFullName
    }
    Text
    {
        id: userIcon
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.normal
        font.family: Regovar.theme.icons.name
        color: hovered ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.dark
        text: hovered ? "h" : "b"
    }
    Text
    {
        id: serverLabel
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        font.pixelSize: Regovar.theme.font.size.small
        font.family: Regovar.theme.font.family
        color: Regovar.theme.primaryColor.back.dark

        text: serverStatus
    }
    Text
    {
        id: serverIcon
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.small
        font.family: Regovar.theme.icons.name
        color: Regovar.theme.primaryColor.back.dark
        text: "F"
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: regovar.logout()
    }



    Component.onCompleted: updateConnectionStatus()

    Connections
    {
        target: regovar.networkManager
        onStatusChanged: updateConnectionStatus()
    }

    Connections
    {
        target: regovar
        onDisplayLoginScreen:
        {
            if (!state)
            {
                root.userFullName = regovar.user.firstname + " " + regovar.user.lastname;
            }
            else
            {
                root.userFullName = qsTr("Not connected");
            }
        }
    }


    function updateConnectionStatus()
    {
        if (regovar.networkManager.status == 0)
        {
            serverLabel.text = qsTr("online");
            serverIcon.text = "F";
            serverLabel.color = Regovar.theme.primaryColor.back.dark;
            serverIcon.color = Regovar.theme.primaryColor.back.dark;
        }
        else
        {
            serverIcon.text = (regovar.networkManager.status == 3) ? "h" : "F";
            serverIcon.color = Regovar.theme.frontColor.danger;
            serverLabel.color = Regovar.theme.frontColor.danger;
            if (regovar.networkManager.status == 1)
                serverLabel.text = qsTr("You must login to use regovar");
            else if (regovar.networkManager.status == 2)
                serverLabel.text = qsTr("Regovar server in error");
            else
                serverLabel.text = qsTr("Regovar server not reachable");
        }
    }
}
