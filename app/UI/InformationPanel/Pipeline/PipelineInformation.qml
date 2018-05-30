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
    icon: "J"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        root.title = "<h1>" + data.name + "</h1>Version: <span style=\"font-family: monospace;\">" + data.version + "</span>";
        root.title += "<br/>" + data.description;


        // Update tabs
        root.tabSharedModel = data;
        var documents = ("documents" in data) ? data["documents"] : {};
        var ttt = listModel.createObject(root);

        if (data.aboutPage !== "")
        {
            ttt.append(
            {   "title": qsTr("About"),
                "icon": "j",
                "source": "qrc:/qml/InformationPanel/Common/WebViewPanel.qml",
                "tabModel" : data.aboutPage
            });
        }
        ttt.append(
            {   "title": qsTr("Information"),
                "icon": "j",
                "source": "qrc:/qml/InformationPanel/Pipeline/InfoPanel.qml"
            });
        // TODO
//        ttt.append({
//                "title": qsTr("Analyses"),
//                "icon": "I",
//                "source": "qrc:/qml/InformationPanel/Pipeline/Analyses.qml"
//            });

        // TODO
//        ttt.append({
//                "title": qsTr("Events"),
//                "icon": "^",
//                "source": "qrc:/qml/InformationPanel/Pipeline/StatsPanel.qml"
//            });

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
