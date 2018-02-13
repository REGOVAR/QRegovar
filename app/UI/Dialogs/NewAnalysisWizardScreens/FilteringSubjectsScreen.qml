import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text:  qsTr("This step is optional.\nIts allow you to link samples to subjects. Select first a sample in the table below, and then click on the oposites buttons to associate an existing subject or create a new one.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

    RowLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10


        ColumnLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text
            {
                id: tableTitle
                text: qsTr("Samples subjects")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.normal
            }

            TableView
            {
                id: samplesSubjectsTable
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.analysesManager.newFiltering.samples

                TableViewColumn { title: qsTr("Sample"); role: "name" }
                TableViewColumn
                {
                    title: qsTr("Identifier")
                    role: "subject"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value ? styleData.value.identifier : ""
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Firstname")
                    role: "subject"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value ? styleData.value.firstname : ""
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Lastname")
                    role: "subject"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value ? styleData.value.lastname : ""
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Sex")
                    role: "subject"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value ? styleData.value.subjectUI.sex : ""
                            font.family: Regovar.theme.icons.name
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Family Number")
                    role: "subject"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value ? styleData.value.familyNumber : ""
                            elide: Text.ElideRight
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Date of birth")
                    role: "subject"
                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value ? styleData.value.dateOfBirth : ""
                            elide: Text.ElideRight
                        }
                    }
                }


                // Special column to display sample's attribute
                Component
                {
                    id: columnComponent_attribute

                    TableViewColumn
                    {
                        width: 100
                        property var attribute

                        delegate: Item
                        {
                            TableViewTextField
                            {
                                id: textField
                                anchors.fill: parent
                                text: attribute.getValue(styleData.value.id)
                                onTextEdited: attribute.setValue(styleData.value.id, text)
                            }
                        }
                    }
                }
            }
        }

        Column
        {
            id: actionColumn
            anchors.top: parent.top
            anchors.topMargin:  tableTitle.height + 10
            Layout.alignment: Qt.AlignTop
            spacing: 10

            property real maxWidth: 0
            onMaxWidthChanged:
            {
                addButton.width = maxWidth;
                remButton.width = maxWidth;
            }

            Button
            {
                id: addButton
                text: qsTr("Select subject")
                onClicked: selectSubjectDialog.open()
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                enabled: samplesSubjectsTable.currentRow > -1
            }
            Button
            {
                id: remButton
                text: qsTr("New subject")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked: newSubjectDialog.open()
                enabled: samplesSubjectsTable.currentRow > -1
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
            if (success)
            {
                var subject = regovar.subjectsManager.getOrCreateSubject(subjectId);
                subject.addSample(samplesSubjectsTable.model[samplesSubjectsTable.currentRow])
            }

        }
    }


    SelectSubjectDialog
    {
        id: selectSubjectDialog
        onSubjectSelected:
        {
            subject.addSample(samplesSubjectsTable.model[samplesSubjectsTable.currentRow])
        }
    }
}
