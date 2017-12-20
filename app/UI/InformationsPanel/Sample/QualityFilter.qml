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
        text: qsTr("Filter")
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
            id: qualFilterLayout
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
                    width: qualFilterLayout.width
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
                    id: qualFilterRepeater

                    Rectangle
                    {
                        width: qualFilterLayout.width
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
                            onEntered: { root.highlightPieSection(filterPieSeries, index, true); parent.hovered = true; }
                            onExited: { root.highlightPieSection(filterPieSeries, index, false); parent.hovered = false; }
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
                id: filterPieSeries
                property string hoveredSerie: ""
            }
        }
    }

    Rectangle
    {
        id: empty
        anchors.fill: parent
        anchors.topMargin: Regovar.theme.font.boxSize.normal
        color: Regovar.theme.boxColor.back
        border.width: 1
        border.color: Regovar.theme.boxColor.border
        visible: false

        Text
        {
            anchors.centerIn: parent
            text: qsTr("Filter quality not available")
            font.pixelSize: Regovar.theme.font.size.title
            color: Regovar.theme.primaryColor.back.light
        }
    }

    function updateViewFromAnalysisModel(model)
    {
        var stats = model.stats;
        var variantTotal = stats["sample_total_variant"];
//        var filter = stats["filter"];
//        var filterDesc = sample.filter_description;
//        var filterChartModel = [];
//        for (var key in filter)
//        {
//            var count = filter[key];
//            filterChartModel.push({
//                "label": key,
//                "percent": (count / variantTotal * 100.0).toFixed(1) + "%",
//                "count": Regovar.formatBigNumber(count),
//                "value": count / variantTotal * 100.0 });
//        }
//        // Populate legend
//        totalVariant.text = Regovar.formatBigNumber(variantTotal);
//        qualFilterRepeater.model = filterChartModel;
//        // Populate Pie slices
//        filterPieSeries.clear()
//        for (var idx=0; idx<filterChartModel.length; idx++)
//        {
//            filterPieSeries.append(filterChartModel[idx]["percent"], filterChartModel[idx]["value"]);
//            var slice = filterPieSeries.at(idx);
//            slice.labelVisible = false;
//        }
    }


    function updateViewFromSampleModel(sample)
    {
        if (!sample || !sample.stats)
        {
            empty.visible = true;
            content.enabled = false;
        }
        else
        {
            var stats = sample.stats;
            var variantTotal = stats["sample_total_variant"];
            var filter = stats["filter"];
            var filterDesc = sample.filter_description;
            var filterChartModel = [];
            for (var key in filter)
            {
                var count = filter[key];
                filterChartModel.push({
                    "label": key,
                    "percent": (count / variantTotal * 100.0).toFixed(1) + "%",
                    "count": Regovar.formatBigNumber(count),
                    "value": count / variantTotal * 100.0 });
            }
            // Populate legend
            totalVariant.text = Regovar.formatBigNumber(variantTotal);
            qualFilterRepeater.model = filterChartModel;
            // Populate Pie slices
            filterPieSeries.clear()
            for (var idx=0; idx<filterChartModel.length; idx++)
            {
                filterPieSeries.append(filterChartModel[idx]["percent"], filterChartModel[idx]["value"]);
                var slice = filterPieSeries.at(idx);
                slice.labelVisible = false;
            }
            empty.visible = false;
            content.enabled = true;
        }
    }


    function highlightPieSection(pieChart, index, exploded)
    {
        pieChart.at(index).exploded = exploded;
    }
}
