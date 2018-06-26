import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property bool editionMode: false
    property File fileModel: null
    property var model
    onModelChanged: setFileModel()
    Component.onDestruction:
    {
        if (fileModel)
        {
            fileModel.dataChanged.disconnect(updateViewFromModel);
        }
    }

    function setFileModel()
    {
        if (model)
        {
            // Disconnect from former model
            if (fileModel)
            {
                fileModel.dataChanged.disconnect(updateViewFromModel);
            }
            // connect to new model and display information
            fileModel = model;
            fileModel.dataChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }


    function updateViewFromModel()
    {
        if (fileModel)
        {
            nameField.text = fileModel.name;
            tagsField.text = fileModel.tags;
            commentField.text = fileModel.comment;

            remoteCreation.text = regovar.formatDate(fileModel.creationDate);
            remoteSize.text = fileModel.sizeUI;
            remoteStatus.text = fileModel.statusUI.label;
            remoteMd5.text = fileModel.md5Sum;
            remoteSource.text = fileModel.sourceUI.filename;
        }
        else
        {
            nameField.text = "";
            tagsField.text = "";
            commentField.text = "";
            remoteCreation.text = "";
            remoteSize.text = "";
            remoteStatus.text = "";
            remoteMd5.text = "";
            remoteSource.text = "";
        }
    }


    function updateModelFromView()
    {
        if (fileModel && nameField.text)
        {
            fileModel.edit(nameField.text, tagsField.text,commentField.text);
        }
    }



    Column
    {
        id: controls
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        Layout.rowSpan: 3
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

    GridLayout
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: controls.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        columnSpacing: 10
        rowSpacing: 10
        columns: 2


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
            placeholder: qsTr("Name of the file")
        }


        Text
        {
            text: qsTr("Tag")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: tagsField
            Layout.fillWidth: true
            enabled: editionMode
            placeholder: qsTr("List of tags")
        }

        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Comment")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextArea
        {
            id: commentField
            Layout.fillWidth: true
            enabled: editionMode
        }

        Text
        {
            text: qsTr("Creation")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: remoteCreation
            Layout.fillWidth: true
            color: Regovar.theme.frontColor.normal
            elide: Text.ElideRight
        }

        Text
        {
            text: qsTr("Size")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: remoteSize
            Layout.fillWidth: true
            color: Regovar.theme.frontColor.normal
            elide: Text.ElideRight
        }

        Text
        {
            text: qsTr("Status")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: remoteStatus
            Layout.fillWidth: true
            color: Regovar.theme.frontColor.normal
            elide: Text.ElideRight
        }

        Text
        {
            text: qsTr("Md5")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: remoteMd5
            Layout.fillWidth: true
            color: Regovar.theme.frontColor.normal
            elide: Text.ElideRight
        }

        Text
        {
            text: qsTr("Source")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.family
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: remoteSource
            Layout.fillWidth: true
            color: Regovar.theme.frontColor.normal
            elide: Text.ElideRight
        }
        Item
        {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
