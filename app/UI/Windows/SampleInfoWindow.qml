import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Sample"

Window
{
    id: sampleInfoDialog
    title: qsTr("Sample Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property int winId

    SampleInformation
    {
        id: sampleInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onSampleInformationSearching: { sampleInfoPanel.reset(); sampleInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        sampleInfoPanel.model = regovar.getWindowModels(winId);
        title = sampleInfoPanel.model.name;
    }
}
