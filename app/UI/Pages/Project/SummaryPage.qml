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
            text: model.name
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
        text: qsTr("This page gives you an overview of the project.")
    }




    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins : 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        rows: 3
        columns: 3
        columnSpacing: 10
        rowSpacing: 10


        Text
        {
            text: qsTr("Name*")
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
            placeholderText: qsTr("Name of the project")
            text: model.name
        }

        Column
        {
            Layout.rowSpan: 2
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
            text: qsTr("Comment")
            Layout.alignment: Qt.AlignTop
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 45
        }
        TextArea
        {
            Layout.fillWidth: true
            enabled: editionMode
            text: model.comment
        }



        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.control
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 45
        }





        TableView
        {
            id: events
            Layout.fillHeight: true
            Layout.fillWidth: true


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
            spacing: 10
            Layout.alignment: Qt.AlignTop


            Button
            {
                id: addFile
                text: qsTr("Add event")
                onClicked:  fileDialog.open()
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
                onClicked: customPopup.open()
            }
        }
    }
}
