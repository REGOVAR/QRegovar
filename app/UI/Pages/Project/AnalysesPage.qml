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
    property var currentAnalysis: null

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
                text: (model) ? model.name : ""
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
        text: qsTr("This page list all analyses that have been done in the current folder.")
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
            id: newAnalysis
            text: qsTr("New")
            onClicked:
            {
                regovar.openNewAnalysisWizard();
                regovar.analysesManager.newFiltering.project = model;
            }
        }
        Button
        {
            id: openAnalysis
            text: qsTr("Open")
            onClicked:
            {
                var analysis = browser.model[browser.currentRow];
                regovar.analysesManager.openAnalysis(analysis.type, analysis.id)
            }
        }
        Button
        {
            id: playPauseAnalysis
            text: qsTr("Pause")
            onClicked:  console.log("Pause/Play analysis")
            enabled: false
        }
        Button
        {
            id: deleteAnalysis
            text: qsTr("Delete")
            onClicked:  console.log("Delete analysis")
            enabled: false
        }
    }

    SplitView
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.left: root.left
        anchors.leftMargin: 10
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
                id: browser
                anchors.fill: parent
                anchors.margins: 10
                anchors.leftMargin: 0
                model: (root.model) ? root.model.analyses : []
                onDoubleClicked:
                {
                    var analysis = browser.model[currentRow];
                    if (analysis)
                    {
                        regovar.analysesManager.openAnalysis(analysis.type, analysis.id);
                    }
                }

                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "type"
                    title: "Type"
                }
                TableViewColumn
                {
                    role: "name"
                    title: "Name"
                }
                TableViewColumn
                {
                    role: "status"
                    title: "Status"
                }
                TableViewColumn
                {
                    role: "updateDate"
                    title: "Date"
                    delegate: Text
                    {
                        anchors.fill: parent
                        anchors.margins: 5
                        verticalAlignment: Text.AlignVCenter
                        text: Regovar.formatShortDate(modelData.dateOfBirth)
                        elide: Text.ElideRight
                    }
                }
                TableViewColumn
                {
                    role: "comment"
                    title: "Comment"
                    width: 400
                }


                onCurrentRowChanged:
                {
                    displayCurrentAnalysisPreview(root.model.analyses[currentRow]);
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
                anchors.leftMargin: 0
                columns: 3
                rowSpacing: 10
                columnSpacing: 10

                Text
                {
                    Layout.fillWidth: true
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    text: currentAnalysis ? currentAnalysis.name : ""
                }

                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    font.family: Regovar.theme.icons.name
                    text: currentAnalysis ? "H" : ""
                }
                Text
                {
                    height: Regovar.theme.font.boxSize.header
                    elide: Text.ElideRight
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                    text: currentAnalysis ? Regovar.formatDate(currentAnalysis.updateDate) : ""
                }

                Rectangle
                {
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: 3
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


    function displayCurrentAnalysisPreview(analysis)
    {
        root.currentAnalysis = analysis;
    }
}
