import QtQuick 2.9
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
    onModelChanged:
    {
        if(model)
        {
            model.dataChanged.connect(function() {updateViewFromModel(model)});
        }

        updateViewFromModel(model)
    }



    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        RowLayout
        {
            anchors.fill: parent
            anchors.margins: 10

            Text
            {
                id: nameLabel
                Layout.fillWidth: true

                font.pixelSize: 22
                font.family: Regovar.theme.font.family
                color: Regovar.theme.frontColor.normal
                verticalAlignment: Text.AlignVCenter
                text: "-"
                elide: Text.ElideRight
            }

            ConnectionStatus { }
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
        text: qsTr("This page gives you an overview of the folder and its content.")
    }

    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins : 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        columns: 3
        columnSpacing: 10
        rowSpacing: 10

        Text
        {
            text: qsTr("Name*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: nameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("Name of the folder")
            text: ""
        }

        Column
        {
            Layout.rowSpan: 2
            Layout.alignment: Qt.AlignTop
            spacing: 10

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
                onClicked: { updateViewFromModel(model); editionMode = false; }
            }
        }

        Text
        {
            text: qsTr("Comment")
            Layout.alignment: Qt.AlignTop
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 45
        }
        TextArea
        {
            id: commentField
            Layout.fillWidth: true
            enabled: editionMode
            text: (model) ? model.comment : ""
        }



        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 45
        }

        TableView
        {
            id: events
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: (root.model) ? root.model.events : []

            TableViewColumn
            {
                title: "Date"
                role: "date"
            }
            TableViewColumn
            {
                title: "Event"
                role: "eventUI"
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
                enabled: false
            }

            Button
            {
                id: editFile
                text: qsTr("Edit event")
                enabled: false
            }
        }
    }

    function updateViewFromModel(data)
    {
        if (data)
        {
            nameLabel.text = data.name;
            nameField.text = data.name;
            commentField.text = data.comment;
        }
    }

    function updateModelFromView()
    {
        if (root.model)
        {
            root.model.name = nameField.text;
            root.model.comment = commentField.text;

            root.model.save();
            nameLabel.text = root.model.name;
        }
    }
}
