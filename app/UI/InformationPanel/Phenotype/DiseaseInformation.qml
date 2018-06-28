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
        if (data && data.loaded && loading)
        {
            root.loading = false;
            // Update title
            root.title = "<h1>" + data.label + "</h1>";

            // Update tabs
            root.tabSharedModel = data;
            var ttt = listModel.createObject(root);
            ttt.append(
                {   "title": qsTr("Information"),
                    "icon": "è",
                    "source": "qrc:/qml/InformationPanel/Phenotype/InfoPanel.qml"
                });
            var pCount = data.phenotypes.rowCount();
            pCount = pCount > 0 ? " (" + pCount + ")" : "";
            ttt.append({
                    "title": qsTr("Phenotypes") + pCount,
                    "icon": "K",
                    "source": "qrc:/qml/InformationPanel/Phenotype/PhenotypesPanel.qml"
                });
            var gCount = data.genes.rowCount();
            gCount = gCount > 0 ? " (" + gCount + ")" : "";
            ttt.append({
                    "title": qsTr("Genes") + gCount,
                    "icon": "ì",
                    "source": "qrc:/qml/InformationPanel/Phenotype/GenesPanel.qml"
                });
            var sCount = data.subjects.rowCount();
            sCount = sCount > 0 ? " (" + sCount + ")" : "";
            ttt.append({
                    "title": qsTr("Subjects") + sCount,
                    "icon": "b",
                    "source": "qrc:/qml/InformationPanel/Phenotype/SubjectsPanel.qml"
                });
            root.tabsModel = ttt;
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
        onDiseaseInformationReady: if (root.model == null) root.model = disease
    }
}
