import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtCharts 2.0
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"

import "../../../InformationsPanel/Sample"



Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (model)
        {
            model.samplesChanged.connect(function() { updateViewFromModel(root.model); });
            updateViewFromModel(model);
        }
    }
    property var statisticsModel

    function updateViewFromModel(model)
    {
        if (model)
        {
            var comboModel = ["All"];
            for (var idx=0; idx<model.samples.length; idx++)
            {
                comboModel.push(model.samples[idx].name);
            }

            levelCombo.model = comboModel;
            refreshGraphs(model);
        }
    }

    function refreshGraphs(sampleModel)
    {
        root.statisticsModel = sampleModel;

        statsOverview.model = statisticsModel;
        statsVariantClasses.model = statisticsModel;
        statsVepConsequences.model = statisticsModel;
        statsVepImpacts.model = statisticsModel;
        qualOverview.model = statisticsModel;
        qualFilter.model = statisticsModel;
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
            spacing: 10

            Text
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: model ? model.name : ""
                font.pixelSize: 20
                font.weight: Font.Black
                color: Regovar.theme.primaryColor.back.dark
                verticalAlignment: Text.AlignVCenter
            }

            ConnectionStatus
            {
                Layout.fillHeight: true
            }
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
        text: qsTr("Statistics about your variants and quality scores from DepthOfCoverage.")
    }


    RowLayout
    {
        id: levelSelector
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10
        spacing: 10

        Text
        {
            height: Regovar.theme.font.boxSize.header
            elide: Text.ElideRight
            text: qsTr("Select a sample:")
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        ComboBox
        {
            id: levelCombo
            height: Regovar.theme.font.boxSize.header - 4
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            onCurrentIndexChanged:
            {
                if (root.model && root.model.samples && root.model.samples.length > 0)
                {
                    if (currentIndex == 0)
                    {
                        root.refreshGraphs(root.model);
                    }
                    else if (currentIndex-1 >= 0 && currentIndex-1 < root.model.samples.length)
                    {
                        root.refreshGraphs(root.model.samples[currentIndex-1]);
                    }
                }
            }
        }
    }



    //
    // Section1 Header : Statistics
    //
    Row
    {
        id: section1Header
        anchors.top : levelSelector.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.topMargin: 30
        spacing: 10

        Text
        {
            height: Regovar.theme.font.boxSize.header
            text: "^"
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Text
        {
            height: Regovar.theme.font.boxSize.header
            elide: Text.ElideRight
            text: qsTr("Statistics")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
    }
    Rectangle
    {
        anchors.top: section1Header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        anchors.topMargin: 0
        height: 1
        color: Regovar.theme.primaryColor.back.normal
    }


    //
    // Section1 Content : Statistics
    //
    Rectangle
    {
        id: section1Content
        anchors.top: section1Header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 290
        color: "transparent"
        clip: true

        ScrollView
        {
            anchors.fill: parent
            horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Row
            {
                spacing: 10

                StatsOverview { id: statsOverview; }
                StatsVariantClasses { id: statsVariantClasses; }
                StatsVepConsequences { id: statsVepConsequences; }
                StatsVepImpacts { id: statsVepImpacts; }
            }
        }
    }


    //
    // Section2 Header : Quality
    //
    Row
    {
        id: section2Header
        anchors.top: section1Content.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.topMargin: 30
        spacing: 10

        Text
        {
            height: Regovar.theme.font.boxSize.header
            text: "^"
            font.family: Regovar.theme.icons.name
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
        Text
        {
            Layout.fillWidth: true
            height: Regovar.theme.font.boxSize.header
            elide: Text.ElideRight
            text: qsTr("Quality")
            font.bold: true
            font.pixelSize: Regovar.theme.font.size.header
            verticalAlignment: Text.AlignVCenter
            color: Regovar.theme.primaryColor.back.normal
        }
    }
    Rectangle
    {
        anchors.top: section2Header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        anchors.topMargin: 0
        height: 1
        color: Regovar.theme.primaryColor.back.normal
    }

    //
    // Section2 Content : Quality
    //
    Rectangle
    {
        id: section2Content
        anchors.top: section2Header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 290
        color: "transparent"
        clip: true

        ScrollView
        {
            anchors.fill: parent
            horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Row
            {
                spacing: 10

                QualityOverview { id: qualOverview; }
                QualityFilter { id: qualFilter; }
            }
        }
    }
}
