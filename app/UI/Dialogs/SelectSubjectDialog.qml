import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

import "../Regovar"
import "../Framework"








Dialog
{
    id: subjectDialog
    title: qsTr("Select subject")
    standardButtons: Dialog.Ok | Dialog.Cancel

    width: 800
    height: 600

    signal subjectSelected(var subject)



    contentItem: Rectangle
    {

        id: root
        color: Regovar.theme.backgroundColor.main
        anchors.fill: parent



        DialogHeader
        {
            id: remoteHeader
            anchors.top : root.top
            anchors.left: root.left
            anchors.right: root.right

            iconText: "b"
            title: qsTr("Subjects")
            text:  qsTr("Below the list of subjects that are already registered on the Regovar server.")
        }

        TextField
        {
            id: remoteFilterField
            anchors.top : remoteHeader.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.margins: 10
            placeholder: qsTr("Search subjects by identifier, firstname, lastname, date of birth, sex, comment, ...")
            text: regovar.subjectsManager.searchQuery
        }

        TableView
        {
            id: subjectsList
            anchors.top : remoteFilterField.bottom
            anchors.left: root.left
            anchors.right: root.right
            anchors.bottom : okButton.top
            anchors.margins: 10

            model: regovar.subjectsManager.subjectsList
            property var statusIcons: ["m", "/", "n", "h"]

            TableViewColumn
            {
                role: "identifier"
                title: "Identifier"
            }
            TableViewColumn
            {
                role: "lastname"
                title: "Lastname"
            }
            TableViewColumn
            {
                role: "firstname"
                title: "Firstname"
            }
    //        TableViewColumn
    //        {
    //            role: "sex"
    //            title: "Sex"
    //        }
            TableViewColumn
            {
                role: "dateofbirth"
                title: "Date of birth"
            }
            TableViewColumn
            {
                role: "comment"
                title: "Comment"
            }
        }

        Button
        {
            id: okButton
            anchors.bottom : root.bottom
            anchors.right: root.right
            anchors.margins: 10

            text: qsTr("Ok")
            onClicked:
            {

                var subject=subjectsList.model[subjectsList.currentRow];
                subjectSelected(subject);
                subjectDialog.accept();
            }
        }

        Button
        {
            id: cancelButton
            anchors.bottom : root.bottom
            anchors.right: okButton.left
            anchors.margins: 10
            text: qsTr("Cancel")
            onClicked: subjectDialog.reject()
        }
    }
}


