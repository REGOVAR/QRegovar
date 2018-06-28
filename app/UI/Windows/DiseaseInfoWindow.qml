import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Phenotype"


Window
{
    id: infoWindow
    title: qsTr("Disease Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId
    Component.onDestruction: regovar.closeWindow(winId);

    DiseaseInformation
    {
        id: diseaseInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onFocusOnWindow: if (wid === winId) { infoWindow.show(); infoWindow.raise(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        diseaseInfoPanel.model = regovar.getWindowModels(winId);
        title = "Disease information";
    }
}
