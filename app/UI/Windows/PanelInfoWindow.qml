import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Panel"


Window
{
    id: panelInfoDialog
    title: qsTr("Panel Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId

    PanelInformation
    {
        id: panelInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onPanelInformationSearching: { panelInfoPanel.reset(); panelInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        panelInfoPanel.model = regovar.getWindowModels(winId);
        title = panelInfoPanel.model.name;
    }
}
