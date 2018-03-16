import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property bool editionMode: false
    property File fileModel: null
    property var model
    onModelChanged: setFileModel(model)
    Component.onDestruction:
    {
        if (fileModel)
        {
            fileModel.dataChanged.disconnect(updateViewFromModel);
        }
    }

    function setFileModel(file)
    {
        if (file)
        {
            // Disconnect from former model
            if (fileModel)
            {
                fileModel.dataChanged.disconnect(updateViewFromModel);
            }
            // connect to new model and display information
            fileModel = file;
            fileModel.dataChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }


    function updateViewFromModel()
    {
        if (fileModel && fileModel.loaded)
        {
            nameField.text = fileModel.name;
            tagsField.text = fileModel.tags;
            commentField.text = fileModel.comment;

            remoteCreation.text = regovar.formatDate(fileModel.creationDate);
            remoteSize.text = fileModel.sizeUI;
            remoteStatus.text = fileModel.statusUI["label"];
            remoteMd5.text = fileModel.md5Sum;
            remoteSource.text = fileModel.sourceUI;

            localCreation.text = "-";
            localSize.text = "-";
            localStatus.text = "-";
            localMd5.text = "-";
            localPath.text = fileModel.localFilePath;
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

            localCreation.text = "";
            localSize.text = "";
            localStatus.text = "";
            localMd5.text = "";
            localPath.text = "";
        }
    }


    function updateModelFromView()
    {
        if (fileModel)
        {
            fileModel.name = nameField.text;
            fileModel.comment = commentField.text;
            fileModel.tags = tagsField.text;
            fileModel.save();
        }
    }


    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10


        // Editable information
        GridLayout
        {
            Layout.fillWidth: true
            rows: 3
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
                placeholder: qsTr("Name of the file")
            }

            Column
            {
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
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 10

            // remote file infos
            GridLayout
            {
                rows: 6
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Text
                    {
                        width: Regovar.theme.font.boxSize.header
                        height: Regovar.theme.font.boxSize.header
                        text: "è"

                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: qsTr("Remote file")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        elide: Text.ElideRight
                    }
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
                    Layout.fillHeight: true
                    width: 1

                }
            }

            Rectangle
            {
                Layout.fillHeight: true
                width: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            // local file infos
            GridLayout
            {
                rows: 6
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Text
                    {
                        width: Regovar.theme.font.boxSize.header
                        height: Regovar.theme.font.boxSize.header
                        text: "ë"

                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.primaryColor.back.dark
                        font.pixelSize: Regovar.theme.font.size.header
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: qsTr("Local file")
                        font.pixelSize: Regovar.theme.font.size.header
                        color: Regovar.theme.primaryColor.back.dark
                        elide: Text.ElideRight
                    }
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
                    id: localCreation
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
                    id: localSize
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
                    id: localStatus
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
                    id: localMd5
                    Layout.fillWidth: true
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Text
                {
                    text: qsTr("Path")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    id: localPath
                    Layout.fillWidth: true
                    color: Regovar.theme.frontColor.normal
                    elide: Text.ElideRight
                }

                Item
                {
                    Layout.fillHeight: true
                    width: 1

                }
            }

        }

    }




}
