import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    property bool editionMode: false

    onModelChanged:
    {
        if (model)
        {
            model.dataChanged.connect(function() { refreshFromModel(); })
            refreshFromModel();
        }
    }

    onVisibleChanged: refreshFromModel()


    function refreshFromModel()
    {
        if (model)
        {
            headerTitle.text = model.name;
            nameField.text = model.name;
            commentField.text = model.comment;
            statusField.text = model.status;
            typeField.text = model.type;
            refField.text = model.refName;
            samplesRepeater.model = model.samples;
            annotationsRepeater.model = model.selectedAnnotationsDB;
            //eventsTreeView.model = ...
        }
    }


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
            id: headerTitle
            anchors.fill: header
            anchors.margins: 10
            font.pixelSize: 20
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
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
        text: qsTr("This page give you an overview of the analysis.")
    }


    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        rows: 11
        columns: 3
        columnSpacing: 10
        rowSpacing: 10


        Text
        {
            text: qsTr("Name*")
            font.bold: true
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            id: nameField
            Layout.fillWidth: true
            enabled: editionMode
            placeholderText: qsTr("Name of the analysis")
            onTextChanged: if (model) model.name = text
        }

        Column
        {
            Layout.rowSpan: 10
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
            enabled: editionMode
            height: 3 * Regovar.theme.font.size.normal
            onTextChanged: if (model) model.comment = text
        }


        Text
        {
            text: qsTr("Priority")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        ComboBox
        {
            enabled: editionMode
            model: ["Urgent", "High", "Normal", "Low"]
            currentIndex: 1
        }



        Rectangle
        {
            Layout.columnSpan: 2
            height: 1
            color: Regovar.theme.primaryColor.back.dark
            Layout.fillWidth: true
        }



        Text
        {
            text: qsTr("Status")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: statusField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }

        Text
        {
            text: qsTr("Type")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: typeField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            text: "Filtering Trio"
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }


        Text
        {
            text: qsTr("Referencial")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Text
        {
            id: refField
            Layout.fillWidth: true
            height: Regovar.theme.font.size.header
            color: Regovar.theme.frontColor.normal
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
        }



        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Samples")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Column
        {
            Layout.fillWidth: true

            Repeater
            {
                id: samplesRepeater

                Row
                {
                    Text
                    {
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        width: Regovar.theme.font.size.normal
                        text: modelData.subjectUI.sex == "M" ? "9" :modelData.subjectUI.sex == "F" ? "<" : ""
                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.frontColor.normal
                    }
                    Text
                    {
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: modelData.subjectUI.lastname + " " + modelData.subjectUI.firstname + " (" + modelData.subjectUI.age + ")"
                        elide: Text.ElideRight
                        color: Regovar.theme.frontColor.normal
                    }

                    Text
                    {
                        width: Regovar.theme.font.boxSize.normal
                        font.pixelSize: Regovar.theme.font.size.normal
                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.frontColor.normal
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "{"
                    }
                    Text
                    {
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.frontColor.normal
                        verticalAlignment: Text.AlignVCenter
                        font.family: "monospace"
                        text: modelData.name
                    }
                }
            }
        }

        Text
        {
            Layout.alignment: Qt.AlignTop
            text: qsTr("Annotations")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        Column
        {
            Layout.fillWidth: true

            Repeater
            {
                id: annotationsRepeater

                Text
                {
                    font.pixelSize: Regovar.theme.font.size.normal
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    text: modelData
                }
            }
        }


        Rectangle
        {
            Layout.columnSpan: 2
            height: 1
            color: Regovar.theme.primaryColor.back.dark
            Layout.fillWidth: true
        }


        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Events")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TreeView
        {
            id: eventsTreeView
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



