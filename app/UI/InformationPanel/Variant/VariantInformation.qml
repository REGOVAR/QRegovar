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
    icon: "j"
    updateFromModel: function updateFromModel(data)
    {
        if (data && loading)
        {
            // Update title
            var variant = "chr" + data["chr"] + ":" + data["pos"] + " " + data["ref"] + ">" + data["alt"];
            var gene = data["genename"];
            var ref = data["reference"];
            root.title = "<h1 style=\"font-family: monospace;\">" + variant + "</h1><br/><br/>Gene: <i>" + gene + "</i><br/>Ref: <i>" + ref + "</i>";

            // Update tabs
            root.tabSharedModel = data;
            var ttt = listModel.createObject(root);
            ttt.append({
                    "title": qsTr("Online Tools"),
                    "icon": "è",
                    "source": "qrc:/qml/InformationPanel/Variant/OnlineToolsPanel.qml"
                });
            ttt.append(
                {   "title": qsTr("Information"),
                    "icon": "j",
                    "source": "qrc:/qml/InformationPanel/Variant/InfoPanel.qml"
                });
            /*
            ttt.append({
                    "title": qsTr("Gene"),
                    "icon": "j",
                    "source": "qrc:/qml/InformationPanel/Gene/InfoPanel.qml"
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
            */
            // TODO: Variant AnnotationsPanel
    //        ttt.append({
    //                "title": qsTr("Annotations"),
    //                "icon": "í",
    //                "source": "qrc:/qml/InformationPanel/Variant/AnnotationsPanel.qml"
    //            });
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
        onVariantInformationReady: if (root.model == null) root.model = json
    }
}
