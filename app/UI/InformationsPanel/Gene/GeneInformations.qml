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
        root.title = "<h1>" + data["name"] + "</h1>";
        root.title += "<span style=\"font-family: monospace;\">" + data["symbol"] + " (" + data["hgnc_id"] + ")</span><br>";
        root.title += data["location"];

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Informations"),
                "icon": "j",
                "source": "qrc:/qml/InformationsPanel/Gene/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Online Tools"),
                "icon": "è",
                "source": "qrc:/qml/InformationsPanel/Gene/OnlineToolsPanel.qml"
            });
        ttt.append({
                "title": qsTr("Pubmed") + " (" + data["pubmed"].length + ")",
                "icon": "Y",
                "source": "qrc:/qml/InformationsPanel/Gene/ReferencePanel.qml"
            });
        ttt.append({
                "title": qsTr("Phenotype"),
                "icon": "K",
                "source": "qrc:/qml/InformationsPanel/Phenotype/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Regovar statistics"),
                "icon": "í",
                "source": "qrc:/qml/InformationsPanel/Variant/StatsPanel.qml"
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
