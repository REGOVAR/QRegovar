import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Pages/Analysis"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var currentAnalysis: null
    property QtObject model
    onModelChanged:
    {
        if(model)
        {
            model.dataChanged.connect(updateViewFromModel);
        }
        updateViewFromModel();
    }
    Component.onDestruction:
    {
        model.dataChanged.disconnect(updateViewFromModel);
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
                font.pixelSize: Regovar.theme.font.size.title
                font.weight: Font.Black
                color: Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
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
        icon: "k"
        text: qsTr("This page list all analyses that have been done for the current subject.")
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
            onClicked: regovar.openNewAnalysisWizard()
        }
        Button
        {
            id: openAnalysis
            text: qsTr("Open")
            onClicked: regovar.analysesManager.openAnalysis(currentAnalysis.type, currentAnalysis.id)
        }
    }

    SplitView
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
        anchors.left: root.left
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.right: actionsPanel.left
        anchors.bottom: root.bottom
        orientation: Qt.Vertical

        Rectangle
        {
            id: topPanel
            width: root.width
            Layout.minimumHeight: 200
            Layout.fillHeight: true
            color: Regovar.theme.backgroundColor.main

            TextField
            {
                id: browserSearch
                anchors.top: topPanel.top
                anchors.left: topPanel.left
                anchors.right: topPanel.right
                anchors.topMargin: 10
                iconLeft: "z"
                displayClearButton: true
                placeholder: qsTr("Search analyses by names, dates, comments...")
                onTextChanged: root.model.analyses.proxy.setFilterString(text)
            }

            TableView
            {
                id: browser
                anchors.top: browserSearch.bottom
                anchors.left: topPanel.left
                anchors.right: topPanel.right
                anchors.bottom: topPanel.bottom
                anchors.bottomMargin: 10
                anchors.topMargin: 10
                onDoubleClicked: regovar.analysesManager.openAnalysis(currentAnalysis.type, currentAnalysis.id)

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
                }
                TableViewColumn
                {
                    role: "comment"
                    title: "Comment"
                    width: 400
                }

                onCurrentRowChanged:
                {
                    var idx = root.model.analyses.proxy.getModelIndex(browser.currentRow);
                    var id = root.model.analyses.data(idx, 257); // 257 = Qt::UserRole+1
                    var type = root.model.analyses.data(idx, 261);

                    if (id && type === "analysis")
                    {
                        displayCurrentAnalysisPreview(regovar.analysesManager.getFilteringAnalysis(id));
                    }
                    else if (id && type === "pipeline")
                    {
                        displayCurrentAnalysisPreview(regovar.analysesManager.getPipelineAnalysis(id));
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

            AnalysisPreview
            {
                anchors.fill: parent
                anchors.margins: 10
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                model: currentAnalysis
            }
        } // end bottomPanel
    } // end SplitView


    function updateViewFromModel()
    {
        if (root.model)
        {
            nameLabel.text = root.model.identifier + " : " + root.model.lastname.toUpperCase() + " " + root.model.firstname;
            browser.model = root.model.analyses.proxy;
        }
    }

    function displayCurrentAnalysisPreview(analysis)
    {
        root.currentAnalysis = analysis;
    }
}
