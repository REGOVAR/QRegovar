import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import "../../Regovar"
import "../../Framework"
import "../../InformationPanel/Gene"
import "../../InformationPanel/Phenotype"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property string formerSearch: ""
    function search()
    {
        if (formerSearch != searchField.text)
        {
            regovar.panelsManager.searchPanelEntry(searchField.text);
            formerSearch = searchField.text;
        }
    }

    function onSearchPanelEntryDone(json)
    {
        phenotypesResult.model = json["phenotype"];
        genesResult.model = json["gene"];
    }

    Component.onCompleted: regovar.panelsManager.searchPanelEntryDone.connect(onSearchPanelEntryDone);
    Component.onDestruction: regovar.panelsManager.searchPanelEntryDone.disconnect(onSearchPanelEntryDone);


    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        rows: 2
        columns: 2
        rowSpacing: 10
        columnSpacing: 10


        TextField
        {
            id: searchField
            Layout.fillWidth: true
            iconLeft: "z"
            displayClearButton: true
            text: regovar.searchRequest
            placeholder: qsTr("Search gene, phenotype or disease...")
            onEditingFinished: search()
        }

        Button
        {
            text: qsTr("Search")
            onClicked: search()
        }

        ScrollView
        {
            id: scrollarea
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {

                // Gene
                Column
                {
                    id: genesResult
                    visible: genesResult.count > 0
                    property int count: 0
                    property var model
                    onModelChanged: if (model) { genesResult.count = model.length; }

                    Text
                    {
                        text: genesResult.count + " " + (genesResult.count > 1 ? qsTr("Genes") : qsTr("Gene"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater
                    {
                        model: genesResult.model
                        onModelChanged: genesResult.count = genesResult.model.length
                        PanelSearchEntry
                        {
                            width: scrollarea.viewport.width
                            model: modelData
                            onAdded:
                            {
                                regovar.panelsManager.newPanel.addEntry({"label" : modelData["symbol"], "id": modelData["id"], "details": modelData["id"]});
                                enabled = false;
                            }
                            onShowDetails:
                            {
                                regovar.getGeneInfo(modelData["symbol"]);
                            }
                        }
                    }
                }

                // Phenotype
                Column
                {
                    id: phenotypesResult
                    visible: phenotypesResult.count > 0
                    property int count: 0
                    property var model
                    onModelChanged: if (model) { phenotypesResult.count = model.length; }

                    Text
                    {
                        text: phenotypesResult.count + " " + (phenotypesResult.count > 1 ? qsTr("Phenotypes") : qsTr("Phenotype"))
                        font.pixelSize: Regovar.theme.font.size.normal
                        color: Regovar.theme.primaryColor.back.dark
                        height: Regovar.theme.font.boxSize.normal
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater
                    {
                        model: phenotypesResult.model
                        onModelChanged: phenotypesResult.count = phenotypesResult.model.length

                        PanelSearchEntry
                        {
                            width: scrollarea.viewport.width
                            model: modelData
                            onAdded:
                            {
                                regovar.panelsManager.newPanel.addEntry({"label" : modelData["label"], "id": modelData["id"], "details": modelData["id"]});
                                enabled = false;
                            }
                            onShowDetails:
                            {
                                phenotypeInfoDialog.open();
                                regovar.getPhenotypeInfo(modelData["id"]);
                            }
                        }
                    }
                }

            }
        }
    }

    // Borders
    Rectangle
    {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1

        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1

        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1

        color: Regovar.theme.boxColor.border
    }


//    Connections
//    {
//        target: regovar
//        onGeneInformationReady:  geneInfoDialog.data = json
//    }
//    Dialog
//    {
//        id: geneInfoDialog
//        title: qsTr("Gene Information")
//        visible: false
//        modality: Qt.NonModal
//        width: 500
//        height: 400

//        property alias data: geneInfoPanel.model

//        contentItem: GeneInformation
//        {
//            id: geneInfoPanel
//        }
//    }

//    Connections
//    {
//        target: regovar
//        onVariantInformationReady: phenotypeInfoDialog.data = json
//    }
//    Dialog
//    {
//        id: phenotypeInfoDialog
//        title: qsTr("Gene Information")
//        visible: false
//        modality: Qt.NonModal
//        width: 500
//        height: 400

//        property alias data: phenotypeInfoPanel.model

//        contentItem: PhenotypeInformation
//        {
//            id: phenotypeInfoPanel
//        }
//    }
}
