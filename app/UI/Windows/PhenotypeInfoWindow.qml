import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Phenotype"

Window
{
    id: phenotypeInfoDialog
    title: qsTr("Phenotype Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId

    PhenotypeInformation
    {
        id: phenotypeInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onPhenotypeInformationSearching: { phenotypeInfoPanel.reset(); phenotypeInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        phenotypeInfoPanel.model = regovar.getWindowModels(winId);
        title = "Phenotype information";
    }
}
