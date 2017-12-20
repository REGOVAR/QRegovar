import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtCharts 2.0

import "../../Regovar"

Item
{
    id: root
    width: 450
    height: 250

    property var model
    onModelChanged:
    {
        if ("samples" in model)
        {
            updateViewFromAnalysisModel(model);
        }
        else
        {
            updateViewFromSampleModel(model);
        }
    }

    //
    // Header
    //
    Text
    {
        anchors.top: root.top
        anchors.left: root.left
        text: qsTr("Vep consequences")
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
        height: Regovar.theme.font.boxSize.normal
        verticalAlignment: Text.AlignVCenter
        font.bold: true
    }

    //
    // Content
    //
    Rectangle
    {
        id: content
        anchors.fill: parent
        anchors.topMargin: Regovar.theme.font.boxSize.normal
        color: Regovar.theme.boxColor.back
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        clip: true
        property double minLabelWidth: 30

        RowLayout
        {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            ScrollView
            {
                id: vepConsequencesLayout
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                Layout.fillHeight: true
                Layout.fillWidth: true

                Column
                {
                    Repeater
                    {
                        id: variantClassesRepeater

                        Rectangle
                        {
                            width: vepConsequencesLayout.width
                            height: Regovar.theme.font.boxSize.normal
                            property bool hovered: false
                            color: !hovered ? "transparent" : Regovar.theme.secondaryColor.back.light

                            RowLayout
                            {
                                anchors.fill: parent
                                spacing: 5
                                Text
                                {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    text: " - " + modelData.label + " (" + modelData.percent + ")"
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    color: Regovar.theme.primaryColor.back.normal
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }
                                Text
                                {
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: content.minLabelWidth
                                    text:  modelData.count
                                    font.pixelSize: Regovar.theme.font.size.normal
                                    color: Regovar.theme.primaryColor.back.normal
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    onPaintedWidthChanged: content.minLabelWidth = Math.max(content.minLabelWidth, paintedWidth)
                                }
                            }
                            MouseArea
                            {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: { root.highlightPieSection(variantClassesPieSeries, index, true); parent.hovered = true; }
                                onExited: { root.highlightPieSection(variantClassesPieSeries, index, false); parent.hovered = false; }
                            }
                        }
                    }

                    Item { width: 10; height: 10; }
                }
            }


            ChartView
            {
                Layout.alignment: Qt.AlignTop
                height: parent.height
                width: parent.height
                antialiasing: true
                animationOptions: ChartView.AllAnimations
                backgroundColor: content.color
                legend.visible: false
                margins.top: 0
                margins.bottom: 0
                margins.left: 0
                margins.right: 0


                PieSeries
                {
                    id: variantClassesPieSeries
                    property string hoveredSerie: ""
                }
            }
        }
    }


    function updateViewFromAnalysisModel(model)
    {
        var stats = model.stats;
        var transcriptTotal = stats["total_transcript"];
        if ("vep_consequences" in stats)
        {
            stats = stats["vep_consequences"];

            // Compute : Variant classes
            var vepConsequenceChartModel = [];
            for (var key in stats)
            {
                var count = stats[key];

                vepConsequenceChartModel.push({
                    "label": key,
                    "percent": (count / transcriptTotal * 100.0).toFixed(1) + "%",
                    "count": Regovar.formatBigNumber(count),
                    "value": count / transcriptTotal * 100.0 });
            }
            // Populate legend
            variantClassesRepeater.model = vepConsequenceChartModel;
            // Populate Pie slices
            variantClassesPieSeries.clear();
            for (var idx=0; idx<vepConsequenceChartModel.length; idx++)
            {
                variantClassesPieSeries.append(vepConsequenceChartModel[idx]["percent"], vepConsequenceChartModel[idx]["value"]);
                var slice = variantClassesPieSeries.at(idx);
                slice.labelVisible = false;
            }
        }
        else
        {
            variantClassesPieSeries.clear();
            variantClassesRepeater.model = [];
        }
    }

    function updateViewFromSampleModel(sample)
    {
        if (sample)
        {
            var stats = sample.stats;
            var transcriptTotal = stats["sample_total_variant"];

            // Compute : Variant classes
            var variantClasses = ["not", "ref", "snv", "mnv", "insertion", "deletion", "others"];
            var vclassesNames = {"not": qsTr("Not in this sample"), "ref": qsTr("Reference"), "snv": qsTr("SNV"), "mnv": qsTr("MNV"), "insertion": qsTr("Insertion"), "deletion": qsTr("Deletion"), "others": qsTr("Others")};
            var vepConsequenceChartModel = [];
            variantClasses.forEach(function (vclass)
            {
                var count = stats["variants_classes"][vclass];
                vepConsequenceChartModel.push({
                    "label": vclassesNames[vclass],
                    "percent": (count / transcriptTotal * 100.0).toFixed(1) + " %",
                    "count": Regovar.formatBigNumber(count),
                    "value": count / transcriptTotal * 100.0 });
            });
            // Populate legend
            totalVariant.text = Regovar.formatBigNumber(transcriptTotal);
            variantClassesRepeater.model = vepConsequenceChartModel;
            // Populate Pie slices
            variantClassesPieSeries.clear();
            for (var idx=0; idx<vepConsequenceChartModel.length; idx++)
            {
                variantClassesPieSeries.append(vepConsequenceChartModel[idx]["percent"], vepConsequenceChartModel[idx]["value"]);
                var slice = variantClassesPieSeries.at(idx);
                slice.labelVisible = false;
            }
        }
    }


    function highlightPieSection(pieChart, index, exploded)
    {
        pieChart.at(index).exploded = exploded;
    }
}
