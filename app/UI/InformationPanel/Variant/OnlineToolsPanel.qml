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


    property var variantDBData: root.model ? [root.model["chr"], root.model["pos"], root.model["ref"], root.model["alt"], root.model["reference"]] : []
    property var variantDBList: ListModel
    {
        ListElement
        {
            name : "Marrvel"
            url  : "http://marrvel.org/search/variant/{0}:{1}%20{2}>{3}"
        }
        ListElement
        {
            name : "Varsome"
            url  : "https://varsome.com/variant/{4}/chr{0}-{1}-{2}-{3}"
        }
    }


    property var geneDBData: root.model && "gene" in root.model ? [root.model["gene"]["entrez_id"], root.model["gene"]["ensembl_gene_id"], root.model["gene"]["ucsc_id"]] : []
    property var geneDBList: ListModel
    {
        ListElement
        {
            name : "Entrez Gene"
            url  : "https://view.ncbi.nlm.nih.gov/gene/{0}"
        }
        ListElement
        {
            name : "Ensembl"
            url  : "https://www.ensembl.org/Homo_sapiens/Gene/Summary?g={1}"
        }
        ListElement
        {
            name : "UCSC"
            url  : "https://genome.cse.ucsc.edu/cgi-bin/hgGene?org=Human&hgg_gene={2}"
        }
    }

    property var nucleotideDBData: root.model && "gene" in root.model ? [root.model["gene"]["ena"], root.model["gene"]["refseq_accession"], root.model["gene"]["ccds_id"]] : []
    property var nucleotideDBList: ListModel
    {
        ListElement
        {
            name : "GenBank"
            url  : "https://www.ncbi.nlm.nih.gov/nuccore/{0}"
        }
        ListElement
        {
            name : "RefSeq"
            url  : "https://www.ncbi.nlm.nih.gov/nuccore?term={1}"
        }
        ListElement
        {
            name : "CCDS"
            url  : "https://www.ncbi.nlm.nih.gov/CCDS/CcdsBrowse.cgi?REQUEST=CCDS&DATA={2}"
        }
    }

    property var expresionDBData: root.model && "gene" in root.model ? [root.model["gene"]["symbol"], root.model["gene"]["uniprot_ids"][0]] : []
    property var expressionDBList: ListModel
    {

        ListElement
        {
            name : "Clue"
            url  : "https://clue.io/command?q={0}"
        }
        ListElement
        {
            name : "UniProt"
            url  : "http://www.uniprot.org/uniprot/{1}"
        }
        ListElement
        {
            name : "InterPro"
            url  : "https://www.ebi.ac.uk/interpro/ISearch?query={1}"
        }
        ListElement
        {
            name : "PDBe"
            url  : "https://www.ebi.ac.uk/pdbe/searchResults.html?display=both&term={1}"
        }
    }

    property var clinicalDBData: root.model && "gene" in root.model ? [root.model["gene"]["symbol"], root.model["gene"]["omim_id"]] : []
    property var clinicalDBList: ListModel
    {
        ListElement
        {
            name : "OMIM"
            url  : "https://www.omim.org/entry/{1}"
        }
        ListElement
        {
            name : "Decipher"
            url  : "https://decipher.sanger.ac.uk/search?q={0}"
        }
        ListElement
        {
            name : "Cosmic"
            url  : "http://cancer.sanger.ac.uk/cosmic/gene/overview?ln={0}"
        }
    }


    property var homologsDBData: root.model && "gene" in root.model ? [root.model["gene"]["mgd_id"], root.model["gene"]["rgd_id"]] : []
    property var homologsDBList: ListModel
    {
        ListElement
        {
            name : "Mus musculus"
            url  : "http://www.informatics.jax.org/marker/{0}"
        }
        ListElement
        {
            name : "Rattus norvegicus"
            url  : "https://rgd.mcw.edu/rgdweb/report/gene/main.html?id={1}"
        }
    }

    property var otherDBData: root.model && "gene" in root.model ? [root.model["gene"]["symbol"], root.model["gene"]["hgnc_id"], root.model["gene"]["entrez_id"]] : []
    property var otherDBList: ListModel
    {
        ListElement
        {
            name : "Genatlas"
            url  : "http://genatlas.medecine.univ-paris5.fr/fiche.php?symbol={0}"
        }
        ListElement
        {
            name : "Genecards"
            url  : "http://www.genecards.org/cgi-bin/carddisp.pl?gene={0}"
        }
        ListElement
        {
            name : "Gopubmed"
            url  : "http://www.gopubmed.org/search?t=hgnc&q={0}"
        }
        ListElement
        {
            name : "H_invdb"
            url  : "http://biodb.jp/hfs.cgi?db1=HUGO&type=GENE_SYMBOL&db2=Locusview&id={0}"
        }
        ListElement
        {
            name : "Hgnc"
            url  : "https://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id={1}"
        }
        ListElement
        {
            name : "Kegg_patway"
            url  : "http://www.kegg.jp/kegg-bin/search_pathway_text?map=map&keyword={0}&mode=1&viewImage=true"
        }
        ListElement
        {
            name : "Nih_ghr"
            url  : "https://ghr.nlm.nih.gov/gene/{0}"
        }
        ListElement
        {
            name : "WikiGenes"
            url  : "https://www.wikigenes.org/e/gene/e/{2}.html"
        }
    }




    Column
    {
        x:0
        y:0
        width: root.width

        // Variant resources
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Variant resources")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: variantDBList

            OnlineToolAction
            {
                url: variantDBList.get(index).url
                label: name
                icon: "_"
                model: variantDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }

        // Gene resources
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Gene resources")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: geneDBList

            OnlineToolAction
            {
                url: geneDBList.get(index).url
                label: name
                icon: "_"
                model: geneDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }

        // Homologs
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Homologs")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: homologsDBList

            OnlineToolAction
            {
                url: homologsDBList.get(index).url
                label: name
                icon: "_"
                model: homologsDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }

        // Nucleotide sequence
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Nucleotide sequence")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: nucleotideDBList

            OnlineToolAction
            {
                url: nucleotideDBList.get(index).url
                label: name
                icon: "_"
                model: nucleotideDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }

        // Protein resources
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Protein resources")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: expressionDBList

            OnlineToolAction
            {
                url: expressionDBList.get(index).url
                label: name
                icon: "_"
                model: expresionDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }

        // Clinical resources
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Clinical resources")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: clinicalDBList

            OnlineToolAction
            {
                url: clinicalDBList.get(index).url
                label: name
                icon: "_"
                model: clinicalDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }

        // Other databases
        Rectangle
        {
            width: root.width - 2
            height: Regovar.theme.font.boxSize.header
            color: "transparent"

            Row
            {
                anchors.fill: parent

                Text
                {
                    text: "{"
                    width: Regovar.theme.font.boxSize.header
                    height: Regovar.theme.font.boxSize.header

                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Text
                {
                    text: qsTr("Other databases")
                    height: Regovar.theme.font.boxSize.header
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.header
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Repeater
        {
            model: otherDBList

            OnlineToolAction
            {
                url: otherDBList.get(index).url
                label: name
                icon: "_"
                model: otherDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }
    }
}
