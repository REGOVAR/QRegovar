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


    property var geneDBData: root.model ? [root.model["entrez_id"], root.model["ensembl_gene_id"], root.model["ucsc_id"]] : []
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

    property var nucleotideDBData: root.model ? [root.model["ena"][0], root.model["refseq_accession"][0], root.model["ccds_id"][0]] : []
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

    property var proteinDBData: root.model ? [root.model["uniprot_ids"][0]] : []
    property var proteinDBList: ListModel
    {
        ListElement
        {
            name : "UniProt"
            url  : "http://www.uniprot.org/uniprot/{0}"
        }
        ListElement
        {
            name : "InterPro"
            url  : "https://www.ebi.ac.uk/interpro/ISearch?query={0}"
        }
        ListElement
        {
            name : "PDBe"
            url  : "https://www.ebi.ac.uk/pdbe/searchResults.html?display=both&term={0}"
        }
    }

    property var clinicalDBData: root.model ? [root.model["symbol"], root.model["omim_id"][0]] : []
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


    property var homologsDBData: root.model ? [root.model["mgd_id"][0], root.model["rgd_id"][0]] : []
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

    property var otherDBData: root.model ? [root.model["symbol"], root.model["hgnc_id"], root.model["entrez_id"]] : []
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
                url: toolsList.get(index).url
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
                url: toolsList.get(index).url
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
                url: toolsList.get(index).url
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
            model: proteinDBList

            OnlineToolAction
            {
                url: toolsList.get(index).url
                label: name
                icon: "_"
                model: proteinDBData
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
                url: toolsList.get(index).url
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
                url: toolsList.get(index).url
                label: name
                icon: "_"
                model: otherDBData
                width: root.width - Regovar.theme.font.boxSize.header
            }
        }
    }
}
