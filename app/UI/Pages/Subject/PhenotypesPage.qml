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
    onModelChanged:
    {
        if (model != undefined)
        {
            nameLabel.text = model.identifier + " : " + model.lastname.toUpperCase() + " " + model.firstname;
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
            id: nameLabel
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.right: connectionStatus.left
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.family
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter

            text: "-"
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
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("This page allow you to list all phenotypes and diseases of the subject.")
    }

    ColumnLayout
    {
        id: actionsPanel
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.right: root.right
        anchors.margins : 10
        spacing: 10


        Button
        {
            id: addPhenotype
            Layout.fillWidth: true
            text: qsTr("Add")
            onClicked:  console.log("Open Select Phenotype dialog")
        }
        Button
        {
            id: editPhenotype
            Layout.fillWidth: true
            text: qsTr("Edit")
            onClicked:  console.log("Open Select Phenotype dialog")
        }
        Button
        {
            id: removePhenotype
            Layout.fillWidth: true
            text: qsTr("Remove")
            onClicked:  console.log("Remove phenotype entry")
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

        Rectangle
        {
            id: topPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200

            TableView
            {
                id: phenotypeList
                anchors.fill: parent
                anchors.margins: 10
                model: (root.model) ? root.model.phenotypes : []

                TableViewColumn
                {
                    role: "label"
                    title: "Phenotype"
                }
                TableViewColumn
                {
                    role: "genes"
                    title: "Genes of interest"
                }
                TableViewColumn
                {
                    role: "comment"
                    title: "Comment"
                }
                TableViewColumn
                {
                    role: "lastUpdate"
                    title: "Date"
                }
                TableViewColumn
                {
                    role: "comment"
                    title: "Comment"
                    width: 400
                }


                onCurrentRowChanged:
                {
                    displayCurrentPhenotypeDetails(root.model.phenotypes[currentRow]);
                }
            }
        } // end topPanel

        Rectangle
        {
            id: bottomPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200

            GridLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                rows:2
                columns:2
                rowSpacing: 10
                columnSpacing: 10

                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    text: qsTr("Definition")
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    text: qsTr("Associated phenotype")
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
                TextArea
                {
                    Layout.minimumWidth: 300
                    Layout.fillHeight: true
                }

                TableView
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true


                    TableViewColumn
                    {
                        role: "id"
                        title: "Id"
                    }
                    TableViewColumn
                    {
                        role: "label"
                        title: "Name"
                    }
                    TableViewColumn
                    {
                        role: "genes"
                        title: "Associated genes"
                    }
                }
            }

        } // end bottomPanel
    } // end SplitView


    function displayCurrentAnalysisPreview(analysis)
    {
        root.currentAnalysis = analysis;
    }
}
