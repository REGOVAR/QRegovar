import QtQuick 2.7
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
                        onEntered: parent.color = Regovar.theme.secondaryColor.back.light
                        onExited: parent.color = Regovar.theme.frontColor.normal
                        onClicked: Qt.openUrlExternally("https://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=" + geneData["hgnc_id"])
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
                    text: qsTr("Size:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? "X kb (Y exons)" : ""
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
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
                Text
                {
                    Layout.fillWidth: true
                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec tortor ante. In dictum tempor libero, id fringilla elit ornare nec. Nulla vitae consequat tellus. Maecenas condimentum facilisis diam, non venenatis lacus euismod eu. Curabitur ornare, nisi eget gravida fringilla, lacus mi commodo turpis, vitae fringilla orci leo suscipit mauris."
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    wrapMode: Text.WordWrap
                }
                Text
                {
                    Layout.fillWidth: true
                    text: qsTr("Read more...")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Regovar.theme.secondaryColor.back.light
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
                    text: qsTr("Approved symbol:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    Layout.fillWidth: true
                    text: geneData ? geneData["symbol"] + " (" + geneData["hgnc_id"] + ")" : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Regovar.theme.secondaryColor.back.light
                        onExited: parent.color = Regovar.theme.frontColor.normal
                        onClicked: Qt.openUrlExternally("https://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=" + geneData["hgnc_id"])
                    }
                }

                Text
                {
                    text: qsTr("Approved name:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: geneData ? geneData["name"] : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    text: qsTr("Former symbols:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: geneData ? String(geneData["prev_name"]) : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    text: qsTr("Synonyms:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: geneData ? String(geneData["alias_symbol"]) : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    text: qsTr("Locus type:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: geneData ? geneData["locus_type"] : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    text: qsTr("Chromosomal location:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: geneData ? geneData["location_sortable"] : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    text: qsTr("Size:")
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.primaryColor.back.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    text: geneData ? "X kb (Y exons)" : ""
                    height: Regovar.theme.font.boxSize.normal
                    color: Regovar.theme.frontColor.normal
                    font.pixelSize: Regovar.theme.font.size.normal
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
