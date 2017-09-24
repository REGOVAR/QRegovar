import QtQuick 2.7
import QtQuick.Layouts 1.1

import "../Regovar"


GridLayout
{
    id: root
    implicitWidth: 300
    property string userFullName: qsTr("Anonymous")
    property string serverStatus: "online"

    rows:2
    columns: 2
    rowSpacing: 2
    columnSpacing: 10

    Text
    {
        id: userLabel
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        font.pixelSize: Regovar.theme.font.size.control
        font.family: Regovar.theme.font.familly
        color: Regovar.theme.primaryColor.back.dark
        text: userFullName
    }
    Text
    {
        id: userIcon
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.control
        font.family: Regovar.theme.icons.name
        color: Regovar.theme.primaryColor.back.dark
        text: "b"
    }
    Text
    {
        id: serverLabel
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        font.pixelSize: Regovar.theme.font.size.content
        font.family: Regovar.theme.font.familly
        color: Regovar.theme.primaryColor.back.dark

        text: serverStatus
    }
    Text
    {
        id: serverIcon
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: Regovar.theme.font.size.content
        font.family: Regovar.theme.icons.name
        color: Regovar.theme.primaryColor.back.dark
        text: "F"
    }

    Component.onCompleted: updateConnectionStatus()

    Connections
    {
        target: regovar
        onConnectionStatusChanged: updateConnectionStatus()
    }

    function updateConnectionStatus()
    {
        if (regovar.connectionStatus == 0)
        {
            serverLabel.text = qsTr("online");
            serverIcon.text = "F";
            serverLabel.color = Regovar.theme.primaryColor.back.dark;
            serverIcon.color = Regovar.theme.primaryColor.back.dark;
        }
        else
        {
            serverIcon.text = (regovar.connectionStatus == 3) ? "h" : "F";
            serverIcon.color = Regovar.theme.frontColor.danger;
            serverLabel.color = Regovar.theme.frontColor.danger;
            if (regovar.connectionStatus == 1)
                serverLabel.text = qsTr("You must login to use regovar");
            else if (regovar.connectionStatus == 2)
                serverLabel.text = qsTr("Regovar server in error");
            else
                serverLabel.text = qsTr("Regovar server not reachable");
        }
    }
}
