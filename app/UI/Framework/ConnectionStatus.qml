import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import Regovar.Core 1.0

import "qrc:/qml/Regovar"


Button
{
    id: root
    implicitWidth: 150
    height: 50
    property string userFullName: ""
    property int serverStatus: -1
    property real serverProgress: regovar.serverTasks.progress
    property User currentUser
    onClicked: regovar.openServerTasksWindow()
    Component.onCompleted:
    {
        setModel();
        updateConnectionStatus();
    }

    ToolTip.text: qsTr("Display tasks in progress server side")
    ToolTip.visible: hovered
    ToolTip.delay: 500


    contentItem: GridLayout
    {
        anchors.centerIn: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        rows:2
        columns: 2
        rowSpacing: 2
        columnSpacing: 10

        Text
        {
            id: userIcon
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.icons.name
            color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.primaryColor.back.dark
            text: "b"
        }
        Text
        {
            id: userLabel
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.primaryColor.back.dark
            text:  userFullName
        }
        Text
        {
            id: serverIcon
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.small
            font.family: Regovar.theme.icons.name
            color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.primaryColor.back.dark
            text: "F"
        }
        Text
        {
            id: serverLabel
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.small
            font.family: Regovar.theme.font.family
            color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.primaryColor.back.dark
            text: serverStatus
            visible: !serverGlobalProgress.visible
        }
        Rectangle
        {
            id: serverGlobalProgress
            Layout.alignment: Qt.AlignVCenter
            border.width: 1
            border.color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.boxColor.border
            color: hovered ? "transparent" : Regovar.theme.boxColor.back
            width: 100
            height: 10
            visible: serverStatus === 0 && serverProgress !== -1

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                height: 8
                color: hovered ? Regovar.theme.secondaryColor.front.normal : Regovar.theme.secondaryColor.back.normal

                width: 98 * serverProgress
            }
        }
    }


    background: Rectangle
    {
        color : hovered ? Regovar.theme.secondaryColor.back.normal : ( down ? Regovar.theme.secondaryColor.back.dark: "transparent")
        radius: 2
        Behavior on color
        {
            ColorAnimation
            {
               duration : 150
            }
        }
    }

    Connections
    {
        target: regovar.usersManager
        onUserChanged: setModel()
    }

    Connections
    {
        target: regovar.networkManager
        onStatusChanged: updateConnectionStatus()
    }

    Connections
    {
        target: regovar.usersManager
        onDisplayLoginScreen:
        {
            if (!state)
            {
                root.userFullName = regovar.usersManager.user.firstname + " " + regovar.usersManager.user.lastname;
            }
            else
            {
                root.userFullName = qsTr("Not connected");
            }
        }
    }


    function setModel()
    {
        if (currentUser)
        {
            currentUser.onDataChanged.disconnect(updateName);
        }
        currentUser = regovar.usersManager.user;
        currentUser.onDataChanged.connect(updateName);
        updateName();
    }

    function updateName()
    {
        userFullName = regovar.usersManager.user.firstname + " " + regovar.usersManager.user.lastname;
    }

    function updateConnectionStatus()
    {
        serverStatus = regovar.networkManager.status;

        if (regovar.networkManager.status <= 1 ) // 0=ready, 1=access denied
        {
            serverLabel.text = qsTr("online");
            if (regovar.networkManager.status == 1)
                serverLabel.text = qsTr("You must be logged in to use regovar");
            serverIcon.text = "F";
        }
        else
        {
            serverIcon.text = (regovar.networkManager.status == 3) ? "h" : "F";
            if (regovar.networkManager.status == 2)
                serverLabel.text = qsTr("Regovar server in error");
            else
                serverLabel.text = qsTr("Regovar server unreachable");
        }
    }
}
