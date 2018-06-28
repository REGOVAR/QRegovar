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
    icon: "ì"
    updateFromModel: function updateFromModel(file)
    {
        if (file && file.loaded && loading)
        {
            // Update tabs
            root.tabSharedModel = file;
            var ttt = listModel.createObject(root);
            ttt.append(
                {   "title": qsTr("Information"),
                    "icon": "j",
                    "source": "qrc:/qml/InformationPanel/File/InfoPanel.qml"
                });
            ttt.append(
                {   "title": qsTr("View"),
                    "icon": file.statusUI["icon"],
                    "source": "qrc:/qml/InformationPanel/File/ViewerPanel.qml"
                });

            // TODO
//            ttt.append({
//                    "title": qsTr("Relations"),
//                    "icon": "ê",
//                    "source": "qrc:/qml/InformationPanel/Common/RelationsPanel.qml"
//                });
            // TODO
//            ttt.append({
//                    "title": qsTr("Events"),
//                    "icon": "H",
//                    "source": "qrc:/qml/InformationPanel/Common/EventsPanel.qml"
//                });
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
            root.title = "<h1>" + model.name + "</h1>";
            root.title += qsTr("Status") + ": " + model.statusUI["label"] + "<br/>";
            root.title += qsTr("Size") + ": " + model.sizeUI + "<br/>";
            root.title += qsTr("Last modification") + ": " + regovar.formatDate(model.updateDate);
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
