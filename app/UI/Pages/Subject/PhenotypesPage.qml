import QtQuick 2.9
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

    property Subject model
    property bool isInit: false
    onModelChanged:
    {
        if (model)
        {
            phenotypeList.model = model.phenotypes;
            root.isInit = true;
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
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.right: connectionStatus.left
            anchors.margins: 10
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: model ? model.identifier + " : " + model.lastname.toUpperCase() + " " + model.firstname : ""
        }
        ConnectionStatus
        {
            id: connectionStatus
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
        icon: "k"
        text: qsTr("This page allow you to list all phenotypes and diseases of the subject.")
    }

    ColumnLayout
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.topMargin: Regovar.theme.font.size.header + 10
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: addPhenotype
            Layout.fillWidth: true
            text: qsTr("Add")
            onClicked: newPhenotypeEntryDialog.open()
        }
        Button
        {
            id: removePhenotype
            Layout.fillWidth: true
            text: qsTr("Remove")
            onClicked: root.model.removeHpo(phenotypeList.model.getAt(phenotypeList.currentRow))
        }
        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }


    SplitView
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.left: root.left
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        orientation: Qt.Vertical
        anchors.margins: 10

        Rectangle
        {
            id: topPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200
            Layout.fillHeight: true

            ColumnLayout
            {
                anchors.fill: parent
                anchors.bottomMargin: 10

                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    text: qsTr("Phenotype")
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }

                TableView
                {
                    id: phenotypeList
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TableViewColumn
                    {
                        role: "presence"
                        title: qsTr("Presence")
                        width: 100
                        delegate:  CheckBox
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            text: checked ? qsTr("Present") : qsTr("Absent")
                            color: checked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
                            checked: styleData.value
                            onClicked: root.model.setHpo(regovar.phenotypesManager.getOrCreate(model.id), checked ? "present" : "absent")
                        }
                    }
                    TableViewColumn
                    {
                        role: "label"
                        title: qsTr("Label")
                        width: 400

                        delegate: RowLayout
                        {
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            spacing: 10

                            ButtonInline
                            {
                                iconTxt: "z"
                                text: ""
                                onClicked: regovar.getPhenotypeInfo(model.id)
                            }
                            Text
                            {
                                Layout.fillWidth: true
                                font.pixelSize: Regovar.theme.font.size.normal
                                font.family: Regovar.theme.font.family
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                text: styleData.value + (model.id.startsWith("HP:") ? "" : " (" + model.id + ")")
                            }
                        }
                    }
                    TableViewColumn
                    {
                        role: "diseasesFreq"
                        title: qsTr("Disease Freq")
                        horizontalAlignment: Text.AlignRight
                    }
                    TableViewColumn
                    {
                        role: "genesFreq"
                        title: qsTr("Genes Freq")
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        } // end topPanel

        Rectangle
        {
            id: bottomPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200

            ColumnLayout
            {
                anchors.fill: parent
                anchors.topMargin: 10
                spacing: 10

                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    text: qsTr("Caracteristics")
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }

                Rectangle
                {
                    color: "transparent"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    border.width: 1
                    border.color: Regovar.theme.boxColor.border
                    Text
                    {
                        anchors.centerIn: parent
                        text: qsTr("Not yet implemented")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.frontColor.disable
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

        } // end bottomPanel
    } // end SplitView

    NewPhenotypeEntryDialog
    {
        id: newPhenotypeEntryDialog
        onAddPhenotype: root.model.setHpo(regovar.phenotypesManager.getOrCreate(phenoId))
    }


    function displayCurrentAnalysisPreview(analysis)
    {
        root.currentAnalysis = analysis;
    }
}
