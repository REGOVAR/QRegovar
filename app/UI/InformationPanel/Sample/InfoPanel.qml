import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property bool editionMode: false
    property Sample sampleModel: null
    property var model
    onModelChanged: setSampleModel(model)
    Component.onDestruction:
    {
        if (sampleModel)
        {
            sampleModel.dataChanged.disconnect(updateViewFromModel);
        }
    }

    function setSampleModel(sample)
    {
        if (sample)
        {
            // Disconnect from former model
            if (sampleModel)
            {
                sampleModel.dataChanged.disconnect(updateViewFromModel);
            }
            // connect to new model and display information
            sampleModel = sample;
            sampleModel.dataChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }

    function updateViewFromModel()
    {
        if (sampleModel && sampleModel.loaded)
        {
            nameField.text = sampleModel.name;
            comment.text = sampleModel.comment;
            creation.text = regovar.formatDate(sampleModel.createDate);
            vcfFile.text = sampleModel.source.name;
            reference.text = sampleModel.reference.name;
            subject.text = qsTr("No subject associated to this sample");

            if (sampleModel.subject)
            {
                subject.text = sampleModel.subject.identifier + " " + sampleModel.subject.lastname + " " + sampleModel.subject.firstname;
            }
        }
        else
        {
            nameField.text = "";
            comment.text = "";
            creation.text = "";
            vcfFile.text = "";
            reference.text = "";
            subject.text = "";
        }
    }


    function updateModelFromView()
    {
        if (model)
        {
            sampleModel.name = nameField.text;
            sampleModel.comment = comment.text;
            sampleModel.save();
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
                placeholder: qsTr("Name of the sample")
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


                Button
                {
                    enabled: !editionMode
                    text: qsTr("New subject")
                    onClicked: newSubjectDialog.show();
                }

                Button
                {
                    enabled: !editionMode
                    text: qsTr("Select subject")
                    onClicked: selectSubjectDialog.open();
                }
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
                id: comment
                Layout.fillWidth: true
                enabled: editionMode
            }

            Text
            {
                text: qsTr("Subject")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            Text
            {
                id: subject
                Layout.fillWidth: true
                anchors.leftMargin: 5
                color: Regovar.theme.frontColor.normal
                elide: Text.ElideRight
            }


        }

        Rectangle
        {
            height: 1
            Layout.fillWidth: true
            color: Regovar.theme.primaryColor.back.normal
        }

        // Read only informations
        GridLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            columnSpacing: 10
            rowSpacing: 5

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
                id: creation
                Layout.fillWidth: true
                color: Regovar.theme.frontColor.normal
                elide: Text.ElideRight
            }

            Text
            {
                text: qsTr("BAM File")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            Rectangle
            {
                id: bamFile
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
                border.width: 1
                border.color: Regovar.theme.boxColor.border

                Text
                {
                    anchors.centerIn: parent
                    text: qsTr("Not yet implemented")
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.primaryColor.back.dark
                }
            }

            Text
            {
                text: qsTr("VCF File")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            Text
            {
                id: vcfFile
                Layout.fillWidth: true
                color: Regovar.theme.frontColor.normal
                elide: Text.ElideRight
            }

            Text
            {
                text: qsTr("Reference")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            Text
            {
                id: reference
                Layout.fillWidth: true
                color: Regovar.theme.frontColor.normal
                elide: Text.ElideRight
            }


            Item
            {
                Layout.columnSpan: 2
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }

    NewSubjectDialog
    {
        id: newSubjectDialog
    }
    Connections
    {
        target: regovar.subjectsManager
        onSubjectCreationDone:
        {
            if (success && visible)
            {
                var subject = regovar.subjectsManager.getOrCreateSubject(subjectId);
                subject.addSample(sampleModel);
                subject.text = subject.identifier + " " + subject.lastname + " " + subject.firstname;
            }

        }
    }

    SelectSubjectDialog
    {
        id: selectSubjectDialog
        onSubjectSelected:
        {
            subject.addSample(sampleModel);
            subject.text = subject.identifier + " " + subject.lastname + " " + subject.firstname;
        }
    }
}
