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
        if (model && "samples" in model)
        {
            root.updateViewFromAnalysisModel(model);
        }
        else
        {
            root.updateViewFromSampleModel(model);
        }
    }

    //
    // Header
    //
    Text
    {
        anchors.top: root.top
        anchors.left: root.left
        text: qsTr("Variant classes")
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

        // NOTICE: due to weird behavior of ChartView with Layout, we manage layout ourself
        ScrollView
        {
            id: variantClassesLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 5
            width: Math.max(0, parent.width - 10 - height)
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {

                RowLayout
                {
                    width: variantClassesLayout.width
                    height: Regovar.theme.font.boxSize.normal

                    Text
                    {
                        Layout.fillHeight: true
                        text: qsTr("Total variants")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }
                    Text
                    {
                        id: totalVariant
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.bold: true
                    }
                }

                Repeater
                {
                    id: variantClassesRepeater

                    Rectangle
                    {
                        width: variantClassesLayout.width
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
            anchors.top: parent.top
            anchors.right: parent.right
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


    function updateViewFromAnalysisModel(model)
    {
        var stats = model.stats;
        var variantTotal = stats["total_variant"];

        // Compute : Variant classes
        var variantClasses = ["ref", "snv", "mnv", "insertion", "deletion", "others"];
        var vclassesNames = {"ref": qsTr("Reference"), "snv": qsTr("SNV"), "mnv": qsTr("MNV"), "insertion": qsTr("Insertion"), "deletion": qsTr("Deletion"), "others": qsTr("Others")};
        var variantClassesChartModel = [];
        variantClasses.forEach(function (vclass)
        {
            var count = stats["variants_classes"][vclass];
            variantClassesChartModel.push({
                "label": vclassesNames[vclass],
                "percent": (count / variantTotal * 100.0).toFixed(1) + "%",
                "count": regovar.formatNumber(count),
                "value": count / variantTotal * 100.0 });
        });
        // Populate legend
        totalVariant.text = regovar.formatNumber(variantTotal);
        variantClassesRepeater.model = variantClassesChartModel;
        // Populate Pie slices
        variantClassesPieSeries.clear();
        for (var idx=0; idx<variantClassesChartModel.length; idx++)
        {
            variantClassesPieSeries.append(variantClassesChartModel[idx]["percent"], variantClassesChartModel[idx]["value"]);
            var slice = variantClassesPieSeries.at(idx);
            slice.labelVisible = false;
        }
    }

    function updateViewFromSampleModel(sample)
    {
        if (sample && sample.stats && sample.stats.length > 0)
        {
            var stats = sample.stats;
            var variantTotal = stats["sample_total_variant"];

            // Compute : Variant classes
            var variantClasses = ["not", "ref", "snv", "mnv", "insertion", "deletion", "others"];
            var vclassesNames = {"not": qsTr("Not in this sample"), "ref": qsTr("Reference"), "snv": qsTr("SNV"), "mnv": qsTr("MNV"), "insertion": qsTr("Insertion"), "deletion": qsTr("Deletion"), "others": qsTr("Others")};
            var variantClassesChartModel = [];
            variantClasses.forEach(function (vclass)
            {
                var count = stats["variants_classes"][vclass];
                variantClassesChartModel.push({
                    "label": vclassesNames[vclass],
                    "percent": (count / variantTotal * 100.0).toFixed(1) + "%",
                    "count": regovar.formatNumber(count),
                    "value": count / variantTotal * 100.0 });
            });
            // Populate legend
            totalVariant.text = regovar.formatNumber(variantTotal);
            variantClassesRepeater.model = variantClassesChartModel;
            // Populate Pie slices
            variantClassesPieSeries.clear();
            for (var idx=0; idx<variantClassesChartModel.length; idx++)
            {
                variantClassesPieSeries.append(variantClassesChartModel[idx]["percent"], variantClassesChartModel[idx]["value"]);
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
