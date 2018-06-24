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
    icon: "4"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        root.title  = "<h1 style=\"font-family: monospace;\">" + data.name + "</h1>";
        var subject = "-";
        if ("subject" in data && data["subject"])
        {
            subject = data["subject"].identifier + " - " + data["subject"].lastname + " " + data["subject"].firstname;
        }
        root.title += "<br/>Subject: " + subject + "<br/>Status: " + data.statusUI["label"];

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Information"),
                "icon": "j",
                "source": "qrc:/qml/InformationPanel/Sample/InfoPanel.qml"
            });
        if (data.status === 2) // ready
        {
            ttt.append(
                {   "title": qsTr("Stats & Quality"),
                    "icon": "^",
                    "source": "qrc:/qml/InformationPanel/Sample/StatsQualPanel.qml"
                });
            // TODO: Sample relations tab
//            ttt.append({
//                    "title": qsTr("Usage"),
//                    "icon": "ê",
//                    "source": "qrc:/qml/InformationPanel/Common/RelationsPanel.qml"
//                });
        }
        ttt.append({
                "title": qsTr("Events"),
                "icon": "è",
                "source": "qrc:/qml/InformationPanel/Common/EventsPanel.qml"
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
        onSampleInformationReady: root.model = sample
    }
}
