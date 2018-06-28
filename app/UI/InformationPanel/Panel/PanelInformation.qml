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
    icon: "q"
    updateFromModel: function updateFromModel(data)
    {
        if (data && data.loaded && loading)
        {
            // Update title
            root.title = "<h1>" + data.name + "</h1>";

            // Update tabs
            root.tabSharedModel = data;
            var ttt = listModel.createObject(root);
            ttt.append(
                {   "title": qsTr("Information"),
                    "icon": "j",
                    "source": "qrc:/qml/InformationPanel/Panel/InfoPanel.qml"
                });
            ttt.append({
                    "title": qsTr("Details"),
                    "icon": "o",
                    "source": "qrc:/qml/InformationPanel/Panel/VersionDetailsPanel.qml"
                });
            // TODO
    //        ttt.append({
    //                "title": qsTr("Events"),
    //                "icon": "H",
    //                "source": "qrc:/qml/InformationPanel/Common/EventsPanel.qml"
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
        onPanelInformationReady: if (root.model == null) root.model = panel
    }
}
