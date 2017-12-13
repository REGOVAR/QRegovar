import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"
import "../Common"

InfoPanel
{
    id: root
    icon: "j"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        var variant = "chr" + data["chr"] + ":" + data["pos"] + " " + data["ref"] + ">" + data["alt"];
        var gene = data["genename"];
        var ref = data["reference"];
        root.title = "<span style=\"font-family: monospace;\">" + variant + "</span><br/><br/><i>Ref: </i>" + ref + "&nbsp;&nbsp;&nbsp;</span>\n\n<i>Gene: </i>" + gene;

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Informations"),
                "icon": "j",
                "source": "../InformationsPanel/Panel/InfoPanel.qmll"
            });
        ttt.append({
                "title": qsTr("Details"),
                "icon": "o",
                "source": "../InformationsPanel/Panel/VersionDetailsPanel.qml"
            });
        ttt.append({
                "title": qsTr("Events"),
                "icon": "H",
                "source": "../InformationsPanel/Common/EventsPanel.qml"
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
        onPanelInformationReady: root.model = json
    }
}
