import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: filterSavingFormPopup
    modality: Qt.WindowModal

    title: qsTr("Create new subject")

    width: 600
    height: 500





    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt


        DialogHeader
        {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            iconText: "b"
            title: qsTr("New subject")
            text: qsTr("Subject are useful for grouping samples, files, and all the information that concerns the same individual. It's also the only way to associate phenotypic data to your samples.\nTo create a subject, only the identifier is required.")
        }

        GridLayout
        {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10

            rows: 6
            columns: 2
            columnSpacing: 30
            rowSpacing: 10



            Text
            {
                text: qsTr("Identifier*")
                font.bold: true
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: idField
                Layout.fillWidth: true
                placeholderText: qsTr("Unique anonymous identifier for the subject")
            }

            Text
            {
                text: qsTr("Firstname")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: firstnameField
                Layout.fillWidth: true
                placeholderText: qsTr("Firstname of the subject")
            }

            Text
            {
                text: qsTr("Lastname")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: lastnameField
                Layout.fillWidth: true
                placeholderText: qsTr("Lastname of the subject")
            }

            Text
            {
                text: qsTr("Date of birth")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: dateOfBirthField
                Layout.fillWidth: true
                placeholderText: qsTr("Date of birth of the subject")
            }

            Text
            {
                text: qsTr("Family number")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: familyNumberField
                Layout.fillWidth: true
                placeholderText: qsTr("Family number of the subject")
            }


            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: qsTr("Comment")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextArea
            {
                id: commentField
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 3 * Regovar.theme.font.size.normal
            }
        }

        Row
        {
            id: footer
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10

            height: Regovar.theme.font.boxSize.normal
            spacing: 10

            Button
            {
                text: qsTr("Cancel")
                onClicked: root.close()
            }
            Button
            {
                text: qsTr("Create")
                enabled: idField.text.trim() != ""
                onClicked:
                {
                    if (idField.text.trim() != "")
                    {
                        loadingIndicator.visible = true;
                        regovar.newSubject(idField.text.trim(), firstnameField.text, lastnameField.text, dateOfBirthField.text, familyNumberField.text, commentField.text);
                    }
                }
            }
        }

        Rectangle
        {
            id: loadingIndicator
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt
            visible: false

            BusyIndicator
            {
                anchors.centerIn: parent
            }
        }
    }

    onVisibleChanged: reset()
    function reset()
    {
        idField.text = "";
        firstnameField.text = "";
        lastnameField.text = "";
        dateOfBirthField.text = "";
        familyNumberField.text = "";
        commentField.text = "";
    }
}
