import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property User model
    property bool editionMode: false

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
            text: qsTr("Regovar server logs")
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
        text: qsTr("This page allow you to browse and manage all users of the application.")
    }

    Column
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: newUser
            text: qsTr("New user")
             onClicked: regovar.openNewProjectWizard()
        }
        Button
        {
            text: editionMode ? qsTr("Save") : qsTr("Edit")
            onClicked:
            {
                editionMode = !editionMode;
                if (!editionMode)
                {
                    // when click on save : update model
                    updateModelFromView();
                }
            }
        }

        Button
        {
            visible: editionMode
            text: qsTr("Cancel")
            onClicked: { updateView1FromModel(model); editionMode = false; }
        }
        Button
        {
            id: deleteUser
            text: qsTr("Delete")
            onClicked:  deleteSelectedProject()
        }
    }




    ColumnLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        spacing: 10

        TextField
        {
            id: searchField
            Layout.fillWidth: true
            placeholder: qsTr("Filter/Search users")
            iconLeft: "z"
            displayClearButton: true

            onTextEdited: regovar.usersManager.users.proxy.setFilterString(text)
            onTextChanged: regovar.usersManager.users.proxy.setFilterString(text)
        }

        TableView
        {
            id: eventsTable
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: regovar.usersManager.users//.proxy

            TableViewColumn
            {
                role: "lastname"
                title: qsTr("Lastname")
            }
            TableViewColumn
            {
                role: "firstname"
                title: qsTr("Firstname")
            }
            TableViewColumn
            {
                role: "login"
                title: qsTr("Login")
            }
            TableViewColumn
            {
                role: "role"
                title: qsTr("Role")
            }
            TableViewColumn
            {
                role: "update"
                title: qsTr("Last connection")
            }
        }
    }


}
