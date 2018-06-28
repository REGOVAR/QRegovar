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
    icon: "j"
    updateFromModel: function updateFromModel(data)
    {
        if (data && data.loaded && !uiLoaded)
        {
            // Update title
            root.title = "<h1>" + data.firstname + " " + data.lastname + "</h1><br/>";
            root.title += qsTr("Last connection:") + " " + regovar.formatDate(data.lastActivity, true);

            // Update tabs
            root.tabSharedModel = data;
            var ttt = listModel.createObject(root);
            ttt.append(
                {   "title": qsTr("Information"),
                    "icon": "j",
                    "source": "qrc:/qml/InformationPanel/User/InfoPanel.qml"
                });
            // TODO
    //        ttt.append({
    //                "title": qsTr("Regovar statistics"),
    //                "icon": "í",
    //                "source": "qrc:/qml/InformationPanel/User/StatsPanel.qml"
    //            });
            // TODO
    //        ttt.append({
    //                "title": qsTr("Events"),
    //                "icon": "è",
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
        onUserInformationReady: root.model = user;
    }
}
