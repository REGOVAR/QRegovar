import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Regovar.Core 1.0
import QtQml.Models 2.2

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/MainMenu"
import "qrc:/qml/Pages/Analysis/Filtering/Quickfilter"

import Regovar.Core 1.0
import Regovar.Widget 1.0


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (root.model != null)
        {
            resultsTree.analysis = root.model;
            resultsTree.model = root.model.results;
        }
    }

    Rectangle
    {
        id: header
        anchors.left: rightPanel.left
        anchors.top: rightPanel.top
        anchors.right: rightPanel.right
        height: 50
        color: Regovar.theme.backgroundColor.alt


        RowLayout
        {
            anchors.bottom: header.bottom
            anchors.top: header.top
            anchors.left: header.left
            anchors.margins: 10
            spacing: 5

            Text
            {
                // visible: model && model.currentFilterName
                text: model && model.currentFilterName ? "D" : "3"
                height: header.height - 20
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                //Layout.fillWidth: true
                text: model && model.currentFilterName ? model.currentFilterName : qsTr("New filter")
                height: header.height - 20
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
            }

            Text
            {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: Regovar.theme.primaryColor.back.dark

                font.pixelSize: Regovar.theme.font.size.header
                text: ( root.model != null) ? ": " + regovar.formatNumber(root.model.results.total) + " " + ((root.model.results.total > 1) ? qsTr("variants") : qsTr("variant")) : ""
            }
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
        icon: "k"
        text: qsTr("This page allow you to filter dynamically variants of the above table. Several tools are available in the left panels:\n" +
                   " - \"Quick filters\": provide you most of common predifined filters;\n"+
                   " - \"Advanced filter\" allow you to create more complexes or custom filters;\n"+
                   " - \"Saved filter\" provide you the list of all filters you saved;\n"+
                   " - \"Selected variant\" allow you to do some actions on the variants selected in the table (by example to export them as csv or generate report);\n"+
                   " - \"Display columns\" allow you to select which columns are displayed in the above table.")
    }

    // TODO: local entries quick filter
//    RowLayout
//    {
//        id: controlPanel
//        anchors.top : header.bottom
//        anchors.left: root.left
//        anchors.right: root.right
//        anchors.margins: 10
//        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

//        spacing: 10

//        TextField
//        {
//            Layout.fillWidth: true
//            iconLeft: "z"
//            displayClearButton: true
//            placeholder: qsTr("Quick search among loaded entries...")
//        }
//    }



    VariantsTable
    {
        id: resultsTree
        //anchors.top: controlPanel.bottom
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: loadingBar.top
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        smooth: true

        Component.onDestruction:
        {
            var position, col;
            for (var idx=columnCount; idx> 1; idx-- )
            {
                col = getColumn(idx-1);
                if (col !== null)
                {
                    analysis.saveHeaderWidth(idx, col.width);
                }
            }

        }
    }


    RowLayout
    {
        id: loadingBar
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        height: Regovar.theme.font.boxSize.small
        spacing: 10

        Item { Layout.fillWidth: true }

        Text
        {
            text: root.model ? qsTr("Loaded entries: ") + regovar.formatNumber(root.model.results.loaded) + " / " + regovar.formatNumber(root.model.results.total) : ""
            font.pixelSize: Regovar.theme.font.size.small
        }
        ButtonInline
        {
            text: qsTr("Load next 1000")
            visible: root.model && root.model.results.loaded < root.model.results.total
            enabled: resultsTree.model ? !resultsTree.model.isLoading : false
            onClicked: resultsTree.model.loadNext()
        }
    }



    Rectangle
    {
        id: busyIndicator
        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: loadingBar.top

        color: Regovar.theme.backgroundColor.overlay
        visible: resultsTree.model ? resultsTree.model.isLoading : false

        MouseArea
        {
            anchors.fill: parent
        }

        BusyIndicator
        {
            anchors.centerIn: parent
        }
    }

}
