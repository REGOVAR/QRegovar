import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property int userId: -1
    property User currentUser

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
            text: qsTr("Regovar users")
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
            onClicked: openNewUser()
        }
        Button
        {
            text: qsTr("Edit")
            onClicked: openEditUser()
        }
        Button
        {
            id: deleteUser
            text: qsTr("Delete")
            onClicked:  openDeleteUser()
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
            id: usersTable
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: regovar.usersManager.users.proxy
            onDoubleClicked: openEditUser()

            TableViewColumn
            {
                role: "isActive"
                title: qsTr("Active ?")
                width: 75
            }
            TableViewColumn
            {
                role: "isAdmin"
                title: qsTr("Admin ?")
                width: 75
            }
            TableViewColumn
            {
                role: "login"
                title: qsTr("Login")
            }
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

    Dialog
    {
        id: userDialog
        property bool edition: false
        width: 400
        height: 500

        contentItem: Rectangle
        {
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt


            DialogHeader
            {
                id: userDialogHeader
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                iconText: "b"
                title: qsTr("New filter condition")
                text: qsTr("Choose the type of condition you want to add and then configure it.")
            }
            GridLayout
            {
                anchors.top: userDialogHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: footer.top
                anchors.margins: 10
                columns: 2


                Text
                {
                    text: qsTr("Login") + "*"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }
                TextField
                {
                    id: loginField
                    Layout.fillWidth: true
                    placeholder: qsTr("Login")
                }
                Text
                {
                    text: userDialog.edition ? qsTr("Password") : qsTr("Password") + "*"
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                    font.bold: !userDialog.edition
                }
                RowLayout
                {
                    Layout.fillWidth: true
                    TextField
                    {
                        id: passwordField
                        Layout.fillWidth: true
                        placeholder: qsTr("Password (set it to erase current)")
                    }
                    Button
                    {
                        text: qsTr("Random")
                        onClicked: passwordField.text = randomPassword()
                    }
                }
                Text
                {
                    text: qsTr("Lastname")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                TextField
                {
                    id: lastnameField
                    Layout.fillWidth: true
                    placeholder: qsTr("Lastname")
                }
                Text
                {
                    text: qsTr("Firstname")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                TextField
                {
                    id: firstnameField
                    Layout.fillWidth: true
                    placeholder: qsTr("Firstname")
                }
                Text
                {
                    text: qsTr("Email")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                TextField
                {
                    id: emailField
                    Layout.fillWidth: true
                    placeholder: qsTr("Email")
                }
                Text
                {
                    text: qsTr("Function")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                TextField
                {
                    id: functionField
                    Layout.fillWidth: true
                    placeholder: qsTr("Function")
                }
                Text
                {
                    text: qsTr("Location")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                TextField
                {
                    id: locationField
                    Layout.fillWidth: true
                    placeholder: qsTr("Location")
                }
                Text
                {
                    text: qsTr("Is active")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                CheckBox
                {
                    id: isActiveField
                    Layout.fillWidth: true
                    text: checked ? qsTr("Yes") : qsTr("No")
                }
                Text
                {
                    text: qsTr("Is admin")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
                CheckBox
                {
                    id: isAdminField
                    Layout.fillWidth: true
                    text: checked ? qsTr("Yes") : qsTr("No")
                }
            }

            Row
            {
                id: footer
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10

                height: Regovar.theme.font.boxSize.normal
                spacing: 10
                layoutDirection: Qt.RightToLeft


                Button
                {
                    text: qsTr("Save")
                    onClicked: save()
                }

                Button
                {
                    text: qsTr("Cancel")
                    onClicked: userDialog.close()
                }

            }

        }
    }

    function openNewUser()
    {
        root.userId = -1;
        loginField.text = "";
        passwordField.text = "";
        lastnameField.text = "";
        firstnameField.text = "";
        emailField.text = "";
        functionField.text = "";
        locationField.text = "";
        isActiveField.checked = true;
        isAdminField.checked = false;
        userDialog.edition = false;

        userDialogHeader.title = qsTr("New user");
        userDialogHeader.text = qsTr("Create new user. Login and password are required to create a new user.");
        userDialog.title = userDialogHeader.title;
        userDialog.open();
    }

    function openEditUser()
    {
        var idx = regovar.usersManager.users.proxy.getModelIndex(usersTable.currentRow);
        var id = regovar.usersManager.users.data(idx, 257); // 257 = Qt::UserRole+1
        var user = regovar.usersManager.getOrCreateUser(id);

        root.currentUser = user;
        root.userId = user.id;
        loginField.text = user.login;
        passwordField.text = "";
        lastnameField.text = user.lastname;
        firstnameField.text = user.firstname;
        emailField.text = user.email;
        functionField.text = user.function;
        locationField.text = user.location;
        isActiveField.checked = user.isActive;
        isAdminField.checked = user.isAdmin;
        userDialog.edition = true;

        userDialogHeader.title = qsTr("Edit user");
        userDialogHeader.text = qsTr("Edit information related to the user.");
        userDialog.title = userDialogHeader.title;
        userDialog.open();
    }

    function randomPassword()
    {
        return Math.random().toString(36).slice(-8);
    }

    function save()
    {
        if (root.userId == -1)
        {
            regovar.usersManager.newUser.login = loginField.text;
            regovar.usersManager.newUser.password = passwordField.text;
            regovar.usersManager.newUser.lastname = lastnameField.text
            regovar.usersManager.newUser.firstname = firstnameField.text;
            regovar.usersManager.newUser.email = emailField.text;
            regovar.usersManager.newUser.function = functionField.text;
            regovar.usersManager.newUser.location = locationField.text;
            regovar.usersManager.newUser.isActive = isActiveField.checked;
            regovar.usersManager.newUser.isAdmin = isAdminField.checked;
            regovar.usersManager.newUser.save(true);
        }
        else
        {
            root.currentUser.login = loginField.text;
            root.currentUser.password = passwordField.text;
            root.currentUser.lastname = lastnameField.text
            root.currentUser.firstname = firstnameField.text;
            root.currentUser.email = emailField.text;
            root.currentUser.function = functionField.text;
            root.currentUser.location = locationField.text;
            root.currentUser.isActive = isActiveField.checked;
            root.currentUser.isAdmin = isAdminField.checked;
            root.currentUser.save();
        }
        userDialog.close(root.currentUser.password != "");
    }
}
