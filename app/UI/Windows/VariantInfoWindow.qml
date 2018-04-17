import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Variant"

Window
{
    id: variantInfoDialog
    title: qsTr("Variant Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property int winId

    VariantInformation
    {
        id: variantInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onVariantInformationSearching: { variantInfoPanel.reset(); variantInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        variantInfoPanel.model = regovar.getWindowModels(winId);
        title = variantInfoPanel.model.name;
    }
}
