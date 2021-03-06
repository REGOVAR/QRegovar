import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/InformationPanel/Common"


ScrollView
{
    id: root
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property var geneData
    property var model
    onModelChanged: updateFromModel(model)
    Component.onCompleted: updateFromModel(model)

    function updateFromModel(data)
    {
        if (data)
        {
            data = data.json;
            if ("gene" in data)
                geneData = data["gene"];
            else
                geneData = data;
        }
    }

    Column
    {
        x: 10
        y: 10
        width: root.width - 30

        TextEdit
        {
            clip: true
            width: root.width - 30
            text: formatInfo(geneData)
            textFormat: TextEdit.RichText
            font.pixelSize: Regovar.theme.font.size.normal + 2
            color: Regovar.theme.frontColor.normal
            readOnly: true
            selectByMouse: true
            selectByKeyboard: true
            wrapMode: TextEdit.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
        Item
        {
            width: 1
            height: 10
        }
    }


    function formatInfo(data)
    {
        if (!data) return "";

        var text = "<b>HGNC information:</b><table>";
        text += "<tr><td><b>Name:</b></td><td>" + data["name"] + "</td></tr>";
        text += "<tr><td><b>Symbol:</b></td><td>" + data["symbol"] + "</td></tr>";
        text += "<tr><td><b>HGNC Id:</b></td><td><a href=\"https://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=" + data["hgnc_id"] + "\">" + data["hgnc_id"] + "</a></td></tr>";
        text += "<tr><td><b>Location:</b></td><td>" + data["location"] + "</td></tr>";
        text += "<tr><td><b>Locus type:</b></td><td>" + data["locus_type"] + "</td></tr>";
        // Former names/symbols
        text += "<tr><td><b>Former names:</b></td><td>";
        if ("prev_symbol" in data)
        {
            for (var idx=0; idx<data["prev_symbol"].length; idx++)
            {
                text += "<i>" + data["prev_symbol"][idx] + "</i>, ";
            }
        }
        text += "</td></tr>";

        // Synonyms
        text += "<tr><td><b>Synonyms:</b></td><td>";
        if ("alias_symbol" in data)
        {
            for (var idx=0; idx<data["alias_symbol"].length; idx++)
            {
                text += "<i>" + data["alias_symbol"][idx] + "</i>, ";
            }
        }
        text += "</td></tr>";
        // text += "<tr><td><b>:</b></td><td>" + data[""] + "</td></tr>";
        text += "</table><br/><br/>";

        // Genomes references
        if ("refgene" in data && data["refgene"].length>0)
        {
            text += "<b>Genome reference:</b><ul>";
            for (var idx=0; idx<data["refgene"].length; idx++)
            {
                text += "<li>" + data["refgene"][idx]["name"] + ": " + formatSize(data["refgene"][idx]) + "</li>";
            }
            text += "</ul>";
        }

        // OMIM Allelic variants references
        if ("omim_variants" in data && data["omim_variants"].length>0)
        {
            text += "<b>OMIM allelic variants:</b>";
            if (data["refgene"].length > 0)
            {
                text += "<ol>";
                for (var idx=0; idx<data["omim_variants"].length; idx++)
                {
                    var d = data["omim_variants"][idx];
                    text += "<li><b>" + d["name"] + "</b><br/>";
                    text += d["mutations"] + " (";
                    if ("dbSnps" in d)
                        text += "<a href=\"http://www.ensembl.org/Homo_sapiens/Variation/Summary?v=" + d["dbSnps"] + ";toggle_HGVS_names=open\">dbSNP:" + d["dbSnps"] + "</a>, ";
                    if ("exacDbSnps" in d)
                        text += "<a href=\"http://exac.broadinstitute.org/awesome?query=" + d["exacDbSnps"] + "\">Exac:" + d["exacDbSnps"] + "</a>, ";
                    if ("clinvarAccessions" in d)
                        text += "<a href=\"https://www.ncbi.nlm.nih.gov/clinvar?term=" + d["clinvarAccessions"] + "\">" + d["clinvarAccessions"] + "</a>, ";
                    text +=")<br/>";
                    text += d["text"] + "<br/></li>";
                }
                text += "</ol>";
            }
            text += "</td></tr>";
        }

        return text;
    }

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
