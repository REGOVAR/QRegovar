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
    icon: "j"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        var variant = "chr" + data["chr"] + ":" + data["pos"] + " " + data["ref"] + ">" + data["alt"];
        var gene = data["genename"];
        var ref = data["reference"];
        root.title = "<h1 style=\"font-family: monospace;\">" + variant + "</h1><br/><br/>Gene: <i>" + gene + "</i><br/>Ref: <i>" + ref + "</i>";

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Informations"),
                "icon": "j",
                "source": "qrc:/qml/InformationsPanel/Variant/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Gene"),
                "icon": "j",
                "source": "qrc:/qml/InformationsPanel/Gene/InfoPanel.qml"
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
        onVariantInformationReady: root.model = json
    }
}
