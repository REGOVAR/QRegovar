import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Regovar.Core 1.0
import QtQml.Models 2.2

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"

import "Quickfilter"

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
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tristique eu lorem sit amet viverra. Vivamus vitae fringilla nibh. Mauris tempor neque eu mauris tristique consequat. Curabitur dui enim, tempor ut quam vel, sagittis tempus diam. Praesent eu erat ante.")
    }


    RowLayout
    {
        id: controlPanel
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        spacing: 10

        TextField
        {
            Layout.fillWidth: true
            iconLeft: "z"
            displayClearButton: true
            placeholder: qsTr("Search by position chr1:422566 or by genes names...")
        }
    }



    VariantsTable
    {
        id: resultsTree
        anchors.top: controlPanel.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: loadingBar.top
        anchors.margins: 10

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

    // Test Embeded QTreeWidget into QML to fix performance issues
//    VariantsTreeWidget
//    {
//        id: resultsTree
//        anchors.top: controlPanel.bottom
//        anchors.left: root.left
//        anchors.right: root.right
//        anchors.bottom: loadingBar.top
//        anchors.margins: 10

//        property FilteringAnalysis analysis
//        onAnalysisChanged:
//        {
//            if (analysis)
//            {
//                resultsTree.setModel(analysis.results);
//            }
//        }
//    }





    // Test with pure QML2 to fix performance issues
/*
    Rectangle
    {
        id: resultsTreeHeader
        anchors.top: controlPanel.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 20

        color: Regovar.theme.boxColor.border
        property real colWidth: 100

        Rectangle
        {
            anchors.fill: parent
            anchors.margins: 1

            color: Regovar.theme.boxColor.back
        }

        Item
        {
            id: indicator
            width: 11
            height: parent.height
            x: 100
            onXChanged: parent.colWidth = x+5

            Rectangle
            {
                width: 1
                height: parent.height
                color: Regovar.theme.boxColor.border
                x: 5
            }

            MouseArea
            {
                anchors.fill: parent
                drag.target: indicator
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: resultsTreeHeader.width - indicator.width
                cursorShape: Qt.SplitHCursor
            }
        }
    }
    ListView
    {
        id: resultsTree
        anchors.top: resultsTreeHeader.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: loadingBar.top
        anchors.margins: 10
        anchors.topMargin: 0
        ScrollBar.vertical: ScrollBar
        {
            width: 10
            policy: ScrollBar.AlwaysOn
        }
        ScrollBar.horizontal: ScrollBar
        {
            height: 10
            policy: ScrollBar.AlwaysOn
        }
        smooth: false
        cacheBuffer: 1000
        clip: true


        property FilteringAnalysis analysis
        onAnalysisChanged:
        {
            if (analysis)
            {
                resultsTree.model = analysis.results;
            }
        }

        delegate: Rectangle
        {
            height: 3*Regovar.theme.font.boxSize.normal
            width: parent.width
            color: index % 2 == 0 ? Regovar.theme.boxColor.back : Regovar.theme.backgroundColor.main

            Row
            {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                spacing: 5
                Repeater
                {
                    model: columns_data

                    Text
                    {
                        objectName: "cellColumn_" + index
                        height: parent.height
                        width: resultsTreeHeader.colWidth[index]
                        text: modelData
                        font.pixelSize: Regovar.theme.font.size.normal
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        renderType: Text.NativeRendering
                        textFormat: Text.PlainText
                    }
                }
            }
        }
    }
*/


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
            visible: root.model.results.loaded < root.model.results.total
            enabled: resultsTree.model ? !resultsTree.model.isLoading : false
            onClicked: resultsTree.model.loadNext()
        }
//        ButtonInline
//        {
//            text: qsTr("Load all")
//            visible: root.model.results.loaded < root.model.results.total
//            enabled: resultsTree.model ? !resultsTree.model.isLoading : false
//            onClicked: resultsTree.model.loadAll()
//        }
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
