import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"
import "../Common"


ScrollView
{
    id: root
    anchors.fill: parent
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property var model
    onModelChanged:  if (model) { updateFromModel(model); }

    function updateFromModel(data)
    {
        if (data)
        {
            if ("gene" in data)
                geneData = data["gene"];
            else
                geneData = data;
        }
    }

    property var geneData


    Column
    {
        x: 10

        Section
        {
            width: root.width - 30
            title: qsTr("Informations")
            expanded: true

            contentItem: GridLayout
            {
                columns: 2
                rows: 9

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Approved symbol:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? geneData["symbol"] + " (" + geneData["hgnc_id"] + ")" : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                        onExited: parent.color = Regovar.theme.frontColor.normal
                        onClicked: Qt.openUrlExternally("https://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=" + geneData["hgnc_id"])
                        cursorShape: "PointingHandCursor"
                    }
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Approved name:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? geneData["name"] : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Chromosomal location:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? geneData["location_sortable"] : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Size") + (geneData && geneData["refgene"] && geneData["refgene"].length > 0 ? " (" + geneData["refgene"][0]["name"] + "):" : "")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData && geneData["refgene"] && geneData["refgene"].length > 0 ? formatSize(geneData["refgene"][0]) : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap

                    function formatSize(data)
                    {
                        var size = Math.round(data["size"]/1000, 0);
                        size = (size > 0) ? size + " Kb" : data["size"] + " b";
                        var exons = data["exon"];
                        exons += " " + ((exons > 1) ? qsTr("exons") : qsTr("exon"));
                        var trx = data["trx"];
                        trx += " " + ((trx > 1) ? qsTr("transcripts") : qsTr("transcript"));
                        return size + ", " + exons + ", " + trx;
                    }
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Locus type:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? geneData["locus_type"] : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }


                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Former symbols:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? String(geneData["prev_name"]) : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Synonyms:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? String(geneData["alias_symbol"]) : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }
            }
        }


        Section
        {
            width: root.width - 30
            title: qsTr("OMIM Description")

            contentItem: ColumnLayout
            {
                TextEdit
                {
                    Layout.fillWidth: true
                    text: geneData ? geneData["omim_description"] : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    wrapMode: Text.WordWrap
                    readOnly: true
                    selectByMouse: true
                    selectByKeyboard: true
                }
                Text
                {
                    Layout.fillWidth: true
                    visible: geneData && geneData["omim_description"]
                    text: "[" + qsTr("Read more...") + "]"
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    MouseArea
                    {
                        anchors.fill: parent
                        enabled: parent.visible
                        hoverEnabled: true
                        cursorShape: "PointingHandCursor"
                        onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                        onExited: parent.color = Regovar.theme.frontColor.normal
                        onClicked: Qt.openUrlExternally("https://www.omim.org/entry/" + geneData["omim_id"][0])
                    }
                }
            }
        }


        Section
        {
            width: root.width - 30
            title: qsTr("External tools")

            contentItem: GridLayout
            {
                columns: 2
                rows: 9

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Genome browser:")
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Column
                {
                    Layout.fillWidth: true
                    Text
                    {
                        Layout.fillWidth: true
                        text: geneData ? "Ensembl (" + geneData["ensembl_gene_id"] + ")" : ""
                        height: Regovar.theme.font.boxSize.normal
                        color: Regovar.theme.frontColor.normal
                        font.pixelSize: Regovar.theme.font.size.normal
                        verticalAlignment: Text.AlignVCenter
                        MouseArea
                        {
                            anchors.fill: parent
                            cursorShape: "PointingHandCursor"
                            hoverEnabled: true
                            onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                            onExited: parent.color = Regovar.theme.frontColor.normal
                            onClicked: Qt.openUrlExternally("https://www.ensembl.org/Homo_sapiens/Gene/Summary?g=" + geneData["ensembl_gene_id"])
                        }
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: geneData ? "Entrez (" + geneData["entrez_id"] + ")" : ""
                        height: Regovar.theme.font.boxSize.normal
                        color: Regovar.theme.frontColor.normal
                        font.pixelSize: Regovar.theme.font.size.normal
                        verticalAlignment: Text.AlignVCenter
                        MouseArea
                        {
                            anchors.fill: parent
                            cursorShape: "PointingHandCursor"
                            hoverEnabled: true
                            onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                            onExited: parent.color = Regovar.theme.frontColor.normal
                            onClicked: Qt.openUrlExternally("https://www.ncbi.nlm.nih.gov/gene/" + geneData["entrez_id"])
                        }
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: geneData ? "UCSC (" + geneData["ucsc_id"] + ")" : ""
                        height: Regovar.theme.font.boxSize.normal
                        color: Regovar.theme.frontColor.normal
                        font.pixelSize: Regovar.theme.font.size.normal
                        verticalAlignment: Text.AlignVCenter
                        MouseArea
                        {
                            anchors.fill: parent
                            cursorShape: "PointingHandCursor"
                            hoverEnabled: true
                            onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                            onExited: parent.color = Regovar.theme.frontColor.normal
                            onClicked: Qt.openUrlExternally("https://genome.cse.ucsc.edu/cgi-bin/hgGene?db=hg38&org=Human&hgg_chrom=none&hgg_type=knownGene&hgg_gene=" + geneData["ucsc_id"])
                        }
                    }
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Nucleotide sequences:")
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Todo"
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Protein:")
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Todo"
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Clinical:")
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Todo"
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }

                Text
                {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("Public databases:")
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Todo"
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
            }
        }
    }
}
