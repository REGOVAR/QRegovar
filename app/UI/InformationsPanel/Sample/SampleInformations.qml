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
    icon: "4"
    updateFromModel: function updateFromModel(data)
    {
        // Update title
        root.title  = "<h1 style=\"font-family: monospace;\">" + data.name + "</h1>";
        var subject = "-";
        if ("subject" in data)
        {
            subject = data.subject.identifier + " - " + data.subject.lastname + " " + data.subject.firstname;
        }
        root.title += "<br/>Subject: " + subject + "<br/>Status: " + data.status;

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Informations"),
                "icon": "j",
                "source": "../InformationsPanel/Sample/InfoPanel.qml"
            });
        ttt.append(
            {   "title": qsTr("Stats & Quality"),
                "icon": "^",
                "source": "../InformationsPanel/Sample/StatsQualPanel.qml"
            });
        ttt.append({
                "title": qsTr("Usage"),
                "icon": "ê",
                "source": "../InformationsPanel/Common/RelationsPanel.qml"
            });
        ttt.append({
                "title": qsTr("Events"),
                "icon": "è",
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
        onSampleInformationReady: root.model = json
    }
}
