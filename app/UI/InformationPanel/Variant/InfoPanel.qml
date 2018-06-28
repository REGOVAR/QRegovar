import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"



Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property bool editionMode: false
    property var model
    onModelChanged: updateViewFromModel()


    function updateViewFromModel()
    {
        if (model)
        {
            annotationField.currentIndex = 0;
            comment.text = "tt";
        }
    }


    function editVariant()
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
            rows: 2
            columns: 3
            columnSpacing: 10
            rowSpacing: 10

            Text
            {
                text: qsTr("Annotation")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            ComboBox
            {
                id: annotationField
                Layout.fillWidth: true
                enabled: editionMode
                model: [qsTr("None"), qsTr("Class 1"), qsTr("Class 2"), qsTr("Class 3"), qsTr("Class 4"), qsTr("Class 5"), qsTr("Blacklisted")]
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
                            editVariant();
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

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

        }

        // TODO: variant regovar statistics
//        Text
//        {
//            Layout.fillWidth: true
//            text: qsTr("Regovar statistics")
//            font.pixelSize: Regovar.theme.font.size.header
//            color: Regovar.theme.primaryColor.back.normal
//        }

//        Rectangle
//        {
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            color: "transparent"

//            Text
//            {
//                anchors.centerIn: parent
//                text: qsTr("Not yet implemented")
//                font.pixelSize: Regovar.theme.font.size.title
//                color: Regovar.theme.primaryColor.back.light
//            }
//        }
    }
}
