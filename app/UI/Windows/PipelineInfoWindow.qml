import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Pipeline"


Window
{
    id: pipelineInfoDialog
    title: qsTr("Pipeline Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId

    PipelineInformation
    {
        id: pipelineInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onPipelineInformationSearching: { pipelineInfoPanel.reset(); pipelineInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        pipelineInfoPanel.model = regovar.getWindowModels(winId);
        title = pipelineInfoPanel.model.name;
    }
}
