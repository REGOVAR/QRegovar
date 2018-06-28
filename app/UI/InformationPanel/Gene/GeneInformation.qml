import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/InformationPanel/Common"

InformationPanel
{
    id: root
    icon: "ì"
    updateFromModel: function updateFromModel(model)
    {
        if (model && model.loaded && loading)
        {
            var data = model.json;
            // Update title
            root.title = "<h1>" + data["name"] + "</h1>";
            root.title += "<span style=\"font-family: monospace;\">" + data["symbol"] + " (" + data["hgnc_id"] + ")</span><br>";
            root.title += data["location"];

            // Update tabs
            root.tabSharedModel = model;
            var ttt = listModel.createObject(root);
            ttt.append(
                {   "title": qsTr("Information"),
                    "icon": "j",
                    "source": "qrc:/qml/InformationPanel/Gene/InfoPanel.qml"
                });
            ttt.append({
                    "title": qsTr("Online Tools"),
                    "icon": "è",
                    "source": "qrc:/qml/InformationPanel/Gene/OnlineToolsPanel.qml"
                });
            var pmCount = model.pubmed.rowCount();
            pmCount = pmCount > 0 ? " (" + pmCount + ")" : "";
            ttt.append({
                    "title": qsTr("Pubmed") + pmCount,
                    "icon": "Y",
                    "source": "qrc:/qml/InformationPanel/Gene/ReferencePanel.qml"
                });
            var pCount = model.phenotypes.rowCount();
            pCount = pCount > 0 ? " (" + pCount + ")" : "";
            ttt.append({
                    "title": qsTr("Phenotypes") + pCount,
                    "icon": "K",
                    "source": "qrc:/qml/InformationPanel/Phenotype/PhenotypesPanel.qml"
                });
            var dCount = model.diseases.rowCount();
            dCount = dCount > 0 ? " (" + dCount + ")" : "";
            ttt.append({
                    "title": qsTr("Diseases") + dCount,
                    "icon": "K",
                    "source": "qrc:/qml/InformationPanel/Phenotype/DiseasesPanel.qml"
                });
            var vCount = model.panels.rowCount();
            vCount = vCount > 0 ? " (" + vCount + ")" : "";
            ttt.append({
                    "title": qsTr("Panels") + vCount,
                    "icon": "q",
                    "source": "qrc:/qml/InformationPanel/Gene/PanelsPanel.qml"
                });


            // TODO
//            ttt.append({
//                    "title": qsTr("Regovar statistics"),
//                    "icon": "í",
//                    "source": "qrc:/qml/InformationPanel/Variant/StatsPanel.qml"
//                });
            root.tabsModel = ttt;
            root.loading = false;
        }
    }

    Component
    {
        id:listModel
        ListModel {}
    }

    Connections
    {
        target: regovar
        onGeneInformationReady: root.model = gene
    }
}
