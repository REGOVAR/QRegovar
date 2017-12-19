import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtCharts 2.0
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"
import "../../../Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged: updateViewFromModel(model)


    function updateViewFromModel(model)
    {
        if (model)
        {
            section1HeaderSamples.model = model.samples;
            section1HeaderSamples.currentIndex = 0;
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


    //
    // Section1 Statistics
    //

    SplitView
    {
        id: section1Content
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        Rectangle
        {
            id: overAllStats
            Layout.minimumWidth: Regovar.theme.font.boxSize.title - 10
            color: "transparent"
            width: 500
            height: 200
            clip: true

            // Header
            Row
            {
                x:0
                id: section1HeaderOverAll
                anchors.top: parent.top
                spacing: 10

                Text
                {
                    width: Regovar.theme.font.boxSize.title - 10
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
                    text: qsTr("Statistics")
                    font.bold: true
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    color: Regovar.theme.primaryColor.back.normal
                }
            }
            Rectangle
            {
                anchors.top: section1HeaderOverAll.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                anchors.topMargin: 0
                anchors.leftMargin: 0
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            // Content
            Rectangle
            {
                anchors.top: section1HeaderOverAll.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                color: "transparent"
                clip: true

                GridLayout
                {
                    anchors.fill: parent
                    columns: 3
                    rows: 6
                    columnSpacing: 10
                    rowSpacing: 5

                    // Filename
                    Rectangle
                    {
                        width: Regovar.theme.font.boxSize.normal
                        height: Regovar.theme.font.boxSize.normal
                        color: "transparent"
                    }
                    Text
                    {
                        text: qsTr("VCF file")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        id: sampleFileField
                        Layout.fillWidth: true
                        text: qsTr("toto.vcf.gz (md5 check ok)")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    // Reference
                    Rectangle
                    {
                        width: Regovar.theme.font.boxSize.normal
                        height: Regovar.theme.font.boxSize.normal
                        color: "transparent"
                    }
                    Text
                    {
                        text: qsTr("VCF header reference")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: qsTr("Hg38 (check)")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    // variant total
                    Rectangle
                    {
                        width: Regovar.theme.font.boxSize.normal
                        height: Regovar.theme.font.boxSize.normal
                        color: "transparent"
                    }
                    Text
                    {
                        text: qsTr("Total variants")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: "600 000"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                        font.family: "monospace"
                    }

                    // variant total
                    Rectangle
                    {
                        width: Regovar.theme.font.boxSize.normal
                        height: Regovar.theme.font.boxSize.normal
                        color: "transparent"
                    }
                    Text
                    {
                        text: qsTr("Total transcript")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: "1 600 000"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                        font.family: "monospace"
                    }

                    // gene total
                    Rectangle
                    {
                        width: Regovar.theme.font.boxSize.normal
                        height: Regovar.theme.font.boxSize.normal
                        color: "transparent"
                    }
                    Text
                    {
                        text: qsTr("Overlapped genes")
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text
                    {
                        text: "16"
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.normal
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                        font.family: "monospace"
                    }

                    Rectangle
                    {
                        Layout.columnSpan: 3
                        color: "transparent"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }
        }

        Rectangle
        {
            id: samplesStats
            color: "transparent"
            width: 700
            height: 200
            clip: true

            // Header
            ComboBox
            {
                id: section1HeaderSamples
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                anchors.topMargin: 2
                height: Regovar.theme.font.boxSize.header - 4 // 4 = 2*2 top/bottom margin

                model: []
                textRole: "name"
                onCurrentIndexChanged: if (model && model.length > 0) updateStatistics(model[currentIndex])
            }
            Rectangle
            {
                anchors.top: section1HeaderSamples.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                anchors.topMargin: 2
                anchors.rightMargin: 0
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            // Content
            ScrollView
            {
                id: section1ContentSamples
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 20 + Regovar.theme.font.boxSize.header

                horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                Row
                {
                    y: 5
                    spacing: 10

                    Rectangle
                    {
                        width: 300
                        height: section1ContentSamples.height
                        border.width: 1
                        border.color: Regovar.theme.boxColor.border
                        color: Regovar.theme.boxColor.back
                        ScrollView
                        {
                            anchors.fill: parent

                            Column
                            {
                                id: variantClassesLayout
                                x: 5
                                y: 5
                                width: parent.width - 10


                                Item
                                {
                                    width: variantClassesLayout.width
                                    height: Regovar.theme.font.boxSize.normal
                                    Text
                                    {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Total variants")
                                        font.pixelSize: Regovar.theme.font.size.normal
                                        color: Regovar.theme.primaryColor.back.normal
                                        height: Regovar.theme.font.boxSize.normal
                                        verticalAlignment: Text.AlignVCenter
                                        font.bold: true
                                    }
                                    Text
                                    {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        id: variantsTotal
                                        Layout.alignment: Qt.AlignRight
                                        text: "-"
                                        font.pixelSize: Regovar.theme.font.size.normal
                                        color: Regovar.theme.primaryColor.back.normal
                                        height: Regovar.theme.font.boxSize.normal
                                        verticalAlignment: Text.AlignVCenter
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

                                        Text
                                        {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: " - " + modelData.label + " (" + modelData.percent + ")"
                                            font.pixelSize: Regovar.theme.font.size.normal
                                            color: Regovar.theme.primaryColor.back.normal
                                            height: Regovar.theme.font.boxSize.normal
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Text
                                        {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text:  modelData.count
                                            font.pixelSize: Regovar.theme.font.size.normal
                                            color: Regovar.theme.primaryColor.back.normal
                                            height: Regovar.theme.font.boxSize.normal
                                            verticalAlignment: Text.AlignVCenter
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
                    }

                    ChartView
                    {
                        height: section1ContentSamples.height
                        width: 200
                        antialiasing: true
                        //animationOptions: ChartView.AllAnimations
                        backgroundColor: Regovar.theme.backgroundColor.main // Regovar.theme.boxColor.back
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

                    /*
                    // === VEP stats II - Consequence ===
                    Rectangle
                    {
                        width: 1
                        height: 1
                        color: Regovar.theme.primaryColor.back.normal
                    }

                    ChartView
                    {
                        height: 150
                        width: 150
                        antialiasing: true
                        animationOptions: ChartView.AllAnimations
                        backgroundColor: Regovar.theme.boxColor.back
                        legend.visible: false
                        margins.top: 0
                        margins.bottom: 0
                        margins.left: 0
                        margins.right: 0


                        PieSeries
                        {
                            PieSlice { label: "Frameshift"; value: 67;  }
                            PieSlice { label: "Coding sequence"; value: 20 }
                            PieSlice { label: "Stop lost"; value: 13 }
                        }
                    }
                    */
                }
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
        spacing: 10

        Text
        {
            width: Regovar.theme.font.boxSize.title - 10
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
        anchors.top: section2Header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10

        color: "transparent"
        height: Regovar.theme.font.boxSize.normal
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


    function updateStatistics(sample)
    {
        if (sample)
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
                variantClassesChartModel = variantClassesChartModel.concat({
                    "label": vclassesNames[vclass],
                    "percent": (count / variantTotal * 100.0).toFixed(1) + " %",
                    "count": count,
                    "value": count / variantTotal * 100.0 });
            });
            // Populate legend
            variantClassesRepeater.model = variantClassesChartModel;
            // Populate Pie slices
            variantClassesPieSeries.clear()
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
