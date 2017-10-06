import QtQuick 2.7
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
            anchors.fill: header
            anchors.margins: 10
            //text: model.name
            font.pixelSize: 20
            font.weight: Font.Black
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
        text: qsTr("Statistics about your variants and quality scores from DepthOfCoverage.")
    }



    Row
    {
        id: overviewStats

        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        spacing: 20

        // === Summary stats ===
        GridLayout
         {

            columns: 3
            rows: 6
            columnSpacing: 10
            rowSpacing: 5


            // ===== Summary Section =====
            Text
            {
                width: Regovar.theme.font.boxSize.title
                height: Regovar.theme.font.boxSize.title
                text: "^"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Regovar.theme.primaryColor.back.normal
            }
            Text
            {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                height: Regovar.theme.font.boxSize.title

                elide: Text.ElideRight
                text: qsTr("Overview")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal

            }

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

        // === VEP stats I - Class ===
        Rectangle
        {
            width: 1
            height: overviewStats.height
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

                id: pieSeries
                PieSlice { label: "SNV"; value: 446903;  }
                PieSlice { label: "insertion"; value: 19102; }
                PieSlice { label: "deletion"; value: 22355; }
                PieSlice { label: "sequence_alteration"; value: 2260; }
            }
        }

        GridLayout
        {
            columns: 3
            rows: 6
            columnSpacing: 10
            rowSpacing: 5

            Text
            {
                Layout.columnSpan: 2
                height: Regovar.theme.font.boxSize.header

                elide: Text.ElideRight
                text: qsTr("Variants classes")
                font.bold: true
                font.pixelSize: Regovar.theme.font.size.header
                verticalAlignment: Text.AlignVCenter
                color: Regovar.theme.primaryColor.back.normal
            }

            // SNV
            Rectangle
            {
                width: Regovar.theme.font.boxSize.normal
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
            }
            Text
            {
                text: qsTr("SNV")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                text: "446 903"
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                font.family: "monospace"
            }

            // Insertion
            Rectangle
            {
                width: Regovar.theme.font.boxSize.normal
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
            }
            Text
            {
                text: qsTr("Insertion")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                text: "19 102"
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                font.family: "monospace"
            }

            // Deletion
            Rectangle
            {
                width: Regovar.theme.font.boxSize.normal
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
            }
            Text
            {
                text: qsTr("Deletion")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                text: "22 355"
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                font.family: "monospace"
            }

            // Sequence alteration
            Rectangle
            {
                width: Regovar.theme.font.boxSize.normal
                height: Regovar.theme.font.boxSize.normal
                color: "transparent"
            }
            Text
            {
                text: qsTr("Sequence alteration")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                text: "2 260"
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.primaryColor.back.normal
                height: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                font.family: "monospace"
            }
        }


        // === VEP stats II - Consequence ===
        Rectangle
        {
            width: 1
            height: overviewStats.height
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



    }

    Text
    {
       text: "Statistics & Quality"
       font.pixelSize: 24
       anchors.centerIn: parent
    }
}
