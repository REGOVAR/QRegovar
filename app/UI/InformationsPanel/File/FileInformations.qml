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
    icon: "ì"
    updateFromModel: function updateFromModel(file)
    {
        if (file)
        {
            // Update tabs
            root.tabSharedModel = data;
            var ttt = listModel.createObject(root);
            ttt.append(
                {   "title": qsTr("Informations"),
                    "icon": "j",
                    "source": "../InformationsPanel/File/InfoPanel.qml"
                });
            ttt.append({
                    "title": qsTr("Relations"),
                    "icon": "ê",
                    "source": "../InformationsPanel/Common/RelationsPanel.qml"
                });
            ttt.append({
                    "title": qsTr("Events"),
                    "icon": "H",
                    "source": "../InformationsPanel/Common/EventsPanel.qml"
                });
            root.tabsModel = ttt;
            root.loading = false;


            file.dataChanged.connect(refreshViewFromModel);
            refreshViewFromModel();
        }
    }

    function refreshViewFromModel()
    {
        if (model && model.loaded)
        {
            root.icon = model.filenameUI["icon"];
            root.title = "<h1>" + model.name + "</h1></br>";
            root.title += qsTr("Status") + ": " + model.statusUI["label"] + "</br>";
            root.title += qsTr("Size") + ": " + model.sizeUI + "</br>";
            root.title += qsTr("Last modification") + ": " + Regovar.formatDate(model.updateDate);
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
        onFileInformationReady: root.model = file
    }
}
