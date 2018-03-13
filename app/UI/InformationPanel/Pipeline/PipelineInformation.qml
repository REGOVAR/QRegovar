import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"
import "../Common"

InformationPanel
{
    id: root
    icon: "J"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        root.title = "<h1>" + data["name"] + "</h1><br/>Version: <span style=\"font-family: monospace;\">" + data["version"] + "</span><br/><br/>" + data["description"];



        // Update tabs
        root.tabSharedModel = data;
        var documents = ("documents" in data) ? data["documents"] : {};
        var ttt = listModel.createObject(root);

        if ("home" in documents)
        {
            ttt.append(
            {   "title": qsTr("Presentation"),
                "icon": "j",
                "source": "qrc:/qml/InformationPanel/Common/WebViewPanel.qml",
                "tabModel" : documents["home"]
            });
        }
        ttt.append(
            {   "title": qsTr("Information"),
                "icon": "j",
                "source": "qrc:/qml/InformationPanel/Pipeline/InfoPanel.qml"
            });
        ttt.append({
                "title": qsTr("Events"),
                "icon": "^",
                "source": "qrc:/qml/InformationPanel/Pipeline/StatsPanel.qml"
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
        onPipelineInformationReady: root.model = json
    }
}
