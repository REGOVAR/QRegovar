import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model
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
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10

            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
            text: regovar.currentProject.name
        }
    }
    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        rows: 8
        columns: 3
        columnSpacing: 10
        rowSpacing: 10


        Text
        {
            text: qsTr("Identifier*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: nameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Unique anonymous identifier")
            text: "MD-65-45"
        }

        Column
        {
            Layout.rowSpan: 7
            Layout.alignment: Qt.AlignTop
            spacing: 10


            Button
            {
                text: editionMode ? qsTr("Save") : qsTr("Edit")
                onClicked:  editionMode = !editionMode
            }

            Button
            {
                visible: editionMode
                text: qsTr("Cancel")
            }
        }




        Text
        {
            text: qsTr("Firstname")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Firstname of the subject")
            text: "Michel"
        }

        Text
        {
            text: qsTr("Lastname")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Lastname of the subject")
            text: "DUPONT"
        }

        Text
        {
            text: qsTr("Date of birth")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Date of birth of the subject")
            text: "1956-03-17"
        }

        Text
        {
            text: qsTr("Family number")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Familly number of the subject")
            text: "1254"
        }

        Text
        {
            text: qsTr("Priority")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        ComboBox
        {
            enabled: editionMode
            model: ["Emergency", "Hight", "Normal", "Low", "None"]
            currentIndex: 1
        }


        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Comment")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextArea
        {
            id: commentField
            Layout.fillWidth: true
            enabled: editionMode
            height: 3 * Regovar.theme.font.size.control
            text: "Comment about the subject"
        }


        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }



        TreeView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true


            TableViewColumn
            {
                title: "Date"
                role: "filenameUI"
            }
            TableViewColumn
            {
                title: "Event"
                role: "filenameUI"
            }
        }


        Column
        {
            Layout.alignment: Qt.AlignTop
            spacing: 10


            Button
            {
                id: addFile
                text: qsTr("Add event")
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
            }
        }

    }
}
