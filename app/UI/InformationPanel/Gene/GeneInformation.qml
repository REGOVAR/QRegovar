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
            {   "title": qsTr("Information"),
                "icon": "j",
                "source": "qrc:/qml/InformationPanel/Gene/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Online Tools"),
                "icon": "è",
                "source": "qrc:/qml/InformationPanel/Gene/OnlineToolsPanel.qml"
            });
        ttt.append({
                "title": qsTr("Pubmed") + " (" + data["pubmed"].length + ")",
                "icon": "Y",
                "source": "qrc:/qml/InformationPanel/Gene/ReferencePanel.qml"
            });
        ttt.append({
                "title": qsTr("Phenotype"),
                "icon": "K",
                "source": "qrc:/qml/InformationPanel/Phenotype/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Regovar statistics"),
                "icon": "í",
                "source": "qrc:/qml/InformationPanel/Variant/StatsPanel.qml"
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
