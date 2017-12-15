import QtQuick 2.9
import QtQuick.Layouts 1.3


import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model

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
            font.pixelSize: 20
            font.weight: Font.bold
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


    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        columns: 3
        rows: 10
        columnSpacing: 30
        rowSpacing: 20


        // ===== Login Section =====
        Row
        {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            height: Regovar.theme.font.boxSize.title

            Text
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                text: "b"

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
                text: qsTr("Regovar user : ") + regovar.user.login
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }


        // password
        Row
        {
            Layout.alignment: Qt.AlignTop
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                color: "transparent"
            }
            Text
            {
                Layout.alignment: Qt.AlignTop
                text: qsTr("Password")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
        }

        Column
        {
            Layout.fillWidth: true
            spacing: 5


            TextField
            {
                id: newPassword
                width: parent.width
                placeholderText: qsTr("New password")
                echoMode: "Password"
            }
            TextField
            {
                id: newPasswordConfirm
                width: parent.width
                placeholderText: qsTr("New password confirmation")
                echoMode: "Password"
            }
            Text
            {
                width: parent.width
                text: qsTr("Set a new password by typing it 2 times with the 2 text fields above.")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }

        // Password confirm panel
        Rectangle
        {
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            width: confirmPasswordButton.width + 20
            Layout.rowSpan: 2
            Layout.fillHeight: true


            ButtonIcon
            {
                id: confirmPasswordButton
                x:10
                y:10
                text: qsTr("Change my password")
                icon: "n"
                onClicked:
                {
                    confirmPasswordButton.enabled = false;
                    confirmPasswordIcon.text = "/";
                    regovar.testConnection(regovarUrl.text, proxyUrl.text);
                }
//                Connections
//                {
//                    target: regovar
//                    onTestConnectionEnd:
//                    {
//                        confirmPasswordIcon.text = "n";
//                        confirmPasswordButton.enabled = true;

//                    }
//                }
            }
            Text
            {
                id: confirmPasswordIcon
                anchors.top: confirmPasswordButton.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: confirmPasswordLabel.top
                wrapMode: Text.WordWrap
                text: "n"
                verticalAlignment: Text.AlignVCenter
                font.family: Regovar.theme.icons.name
                font.pixelSize: 30
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                id: confirmPasswordLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                wrapMode: Text.WordWrap
                text: qsTr("Password complexity : OK")
                font.pixelSize: Regovar.theme.font.size.small
                color: Regovar.theme.primaryColor.back.normal
                horizontalAlignment: Text.AlignHCenter
            }

        }

        Rectangle
        {
            width: Regovar.theme.font.boxSize.title
            height: Regovar.theme.font.boxSize.title
            color: "transparent"
        }

        Column
        {
            Layout.fillWidth: true
            spacing: 5

            TextField
            {
                id: oldPassword
                width: parent.width
                placeholderText: qsTr("Current password")
                echoMode: "Password"
            }
            Text
            {
                width: parent.width
                text: qsTr("To confirm your new password you have to type also your current password. Then you have to click on the opposite validate button.")
                font.pixelSize: Regovar.theme.font.size.small
                font.italic: true
                color: Regovar.theme.primaryColor.back.normal
                wrapMode: Text.WordWrap
            }
        }


        // ===== User informations =====
        Row
        {
            Layout.fillWidth: true
            Layout.columnSpan: 3
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
                text: qsTr("User informations")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }
        }



        // Lastname
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
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
            Layout.fillWidth: true
            text: regovar.user.lastname
            placeholderText: qsTr("Lastname")
        }

        // User avatar panel
        Rectangle
        {
            Layout.rowSpan: 5
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
            width: confirmPasswordButton.width + 20
            Layout.fillHeight: true


            Text
            {
                anchors.centerIn: parent
                text: qsTr("Todo : avatar ?")
            }
        }

        // Firstname
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
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
            Layout.fillWidth: true
            text: regovar.user.firstname
            placeholderText: qsTr("Firstname")
        }

        // Email
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
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
            Layout.fillWidth: true
            text: regovar.user ? regovar.user.email : ""
            placeholderText: qsTr("Email")
        }

        // Location
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
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
            Layout.fillWidth: true
            text: regovar.user ? regovar.user.location : ""
            placeholderText: qsTr("Location")
        }

        // Function
        Row
        {
            Rectangle
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
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
            Layout.fillWidth: true
            text: regovar.user ? regovar.user.function : ""
            placeholderText: qsTr("Function")
        }


        Rectangle
        {
            Layout.columnSpan: 3
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}

