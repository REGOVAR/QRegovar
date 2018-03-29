import QtQuick 2.9
import QtQuick.Layouts 1.3
import Regovar.Core 1.0


import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main
    property User model


    Connections
    {
        target: regovar.usersManager
        onUserChanged:
        {
            if (model)
            {
                model.onDataChanged.disconnect(updateViewFromModel);
            }
            model = regovar.usersManager.user;
            model.onDataChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }


    function updateViewFromModel()
    {
        if (model)
        {
            loginField.text = model.login;
            lastnameField.text = model.lastname;
            firstnameField.text = model.firstname;
            emailField.text = model.email;
            locationField.text = model.location;
            functionField.text = model.function;

            newPassword.text = "";
            newPasswordConfirm.text = "";
            //oldPassword.text = "";
        }
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
            text: qsTr("User profile settings")
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
        text: qsTr("Edit your profile information.")
    }


    ColumnLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10


        // USER INFORMATION =======================================================================
        GridLayout
        {
            Layout.fillWidth: true

            columns: 2
            rows: 10
            columnSpacing: 30
            rowSpacing: 20

            Row
            {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                height: Regovar.theme.font.boxSize.title

                Text
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.title
                    text: "\\"

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
                    text: qsTr("User information")
                    font.bold: true
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
            }



            // Login
            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    text: qsTr("Login")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text
            {
                id: loginField
                Layout.fillWidth: true
            }

            // Lastname
            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    text: qsTr("Lastname")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TextField
            {
                id: lastnameField
                Layout.fillWidth: true
                placeholder: qsTr("Lastname")
                onTextEdited: model.lastname = text
            }


            // Firstname
            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    text: qsTr("Firstname")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TextField
            {
                id: firstnameField
                Layout.fillWidth: true
                placeholder: qsTr("Firstname")
                onTextEdited: model.firstname = text
            }

            // Email
            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    text: qsTr("Email")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TextField
            {
                id: emailField
                Layout.fillWidth: true
                placeholder: qsTr("Email")
                onTextEdited: model.email = text
            }

            // Location
            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    text: qsTr("Location")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TextField
            {
                id: locationField
                Layout.fillWidth: true
                placeholder: qsTr("Location")
                onTextEdited: model.location = text
            }


            // Function
            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    text: qsTr("Function")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.normal
                    Layout.alignment: Qt.AlignTop
                    height: Regovar.theme.font.boxSize.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TextField
            {
                id: functionField
                Layout.fillWidth: true
                placeholder: qsTr("Function")
                onTextEdited: model.function = text;
            }

            Row
            {
                Item
                {
                    width: Regovar.theme.font.boxSize.title
                    height: Regovar.theme.font.boxSize.normal
                }
                Button
                {
                    text: qsTr("Save change")
                    onClicked: model.save()
                }
            }

        }


        Item
        {
            width: Regovar.theme.font.boxSize.title
            height: Regovar.theme.font.boxSize.title
        }


        // USER PASSWORD ==========================================================================

        GridLayout
        {
            Layout.fillWidth: true

            columns: 2
            rows: 7
            rowSpacing: 20


            Text
            {
                Layout.row: 0
                Layout.column: 0
                Layout.minimumWidth: Regovar.theme.font.boxSize.title
                Layout.maximumWidth: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                text: "8"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.title
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.back.normal
            }

            Text
            {
                Layout.row: 0
                Layout.column: 1
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.title

                elide: Text.ElideRight
                text: qsTr("Password")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }

            Text
            {
                Layout.row: 1
                Layout.column: 1
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.title

                elide: Text.ElideRight
                text: qsTr("Set a new password by typing it 2 times with the 2 text fields below.")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
            }


            // password
            TextField
            {
                Layout.row: 2
                Layout.column: 1
                Layout.fillWidth: true
                id: newPassword
                width: parent.width
                placeholder: qsTr("New password")
                echoMode: "Password"
            }
            TextField
            {
                Layout.row: 3
                Layout.column: 1
                Layout.fillWidth: true
                id: newPasswordConfirm
                width: parent.width
                placeholder: qsTr("New password confirmation")
                echoMode: "Password"
            }

//            Text
//            {
//                Layout.row: 4
//                Layout.column: 1
//                Layout.fillWidth: true
//                width: parent.width
//                text: qsTr("To confirm your new password you have to type also your current password.")
//                font.pixelSize: Regovar.theme.font.size.normal
//                color: Regovar.theme.primaryColor.back.normal
//                wrapMode: Text.WordWrap
//            }

//            TextField
//            {
//                Layout.row: 5
//                Layout.column: 1
//                Layout.fillWidth: true
//                id: oldPassword
//                width: parent.width
//                placeholder: qsTr("Current password")
//                echoMode: "Password"
//            }
            Button
            {
                Layout.row: 6
                Layout.column: 1
                enabled: false
                text: qsTr("Change my password")
            }
        }



        // HF ====================================================================================
        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.title
            radius: 2
            color: Regovar.theme.backgroundColor.alt
            border.width: 1
            border.color: Regovar.theme.boxColor.border

        }
    }
}

