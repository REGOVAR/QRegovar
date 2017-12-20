import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"
import "../Common"

InformationsPanel
{
    id: root
    icon: "ì"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        var variant = "chr" + data["chr"] + ":" + data["pos"] + " " + data["ref"] + ">" + data["alt"];
        var gene = data["genename"];
        var ref = data["reference"];
        root.title = "<h1>" + data["name"] + "</h1>";
        root.title += "<span style=\"font-family: monospace;\">" + data["symbol"] + " (" + data["hgnc_id"] + ")</span><br>";
        root.title += data["location"];

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Informations"),
                "icon": "j",
                "source": "../InformationsPanel/Gene/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Online Tools"),
                "icon": "è",
                "source": "../InformationsPanel/Gene/OnlineToolsPanel.qml"
            });
        ttt.append({
                "title": qsTr("Pubmed") + " (" + data["pubmed"].length + ")",
                "icon": "Y",
                "source": "../InformationsPanel/Gene/ReferencePanel.qml"
            });
        ttt.append({
                "title": qsTr("Phenotype"),
                "icon": "K",
                "source": "../InformationsPanel/Phenotype/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Regovar statistics"),
                "icon": "í",
                "source": "../InformationsPanel/Variant/StatsPanel.qml"
            });
        root.tabsModel = ttt;
        root.loading = false;
    }

    Component
    {
        id:listModel
        ListModel {}
    }

    Connections
    {
        target: regovar
        onGeneInformationReady: root.model = json
    }
}
