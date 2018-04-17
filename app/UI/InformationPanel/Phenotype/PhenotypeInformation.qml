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
        // Update title
        root.title = "<h1>" + data.label + "</h1>";
        //root.title += "<span style=\"font-family: monospace;\">" + data.id + "</span><br>";
        root.title += data.definition;

        // Update tabs
        root.tabSharedModel = data;
        var ttt = listModel.createObject(root);
        ttt.append(
            {   "title": qsTr("Information"),
                "icon": "è",
                "source": "qrc:/qml/InformationPanel/Phenotype/InfoPanel.qml"
            });
        var dCount = data.diseases.rowCount();
        dCount = dCount > 0 ? " (" + dCount + ")" : "";
        ttt.append({
                "title": qsTr("Diseases") + dCount,
                "icon": "K",
                "source": "qrc:/qml/InformationPanel/Phenotype/DiseasesPanel.qml"
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
        onPhenotypeInformationReady: root.model = phenotype
    }
}
