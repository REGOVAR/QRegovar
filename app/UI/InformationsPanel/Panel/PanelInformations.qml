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
    icon: "q"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        root.title = "<h1>" + data.name + "</h1>";

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Informations"),
                "icon": "j",
                "source": "../InformationsPanel/Panel/InfoPanel.qml"
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
        onPanelInformationReady: root.model = panel
    }
}
