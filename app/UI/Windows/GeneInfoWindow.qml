import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Gene"

Window
{
    id: geneInfoDialog
    title: qsTr("Gene Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId

    GeneInformation
    {
        id: geneInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onGeneInformationSearching: { geneInfoPanel.reset(); geneInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        geneInfoPanel.model = regovar.getWindowModels(winId);
        title = geneInfoPanel.model.name;
    }
}
