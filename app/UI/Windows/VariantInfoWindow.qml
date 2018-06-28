import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/Variant"

Window
{
    id: infoWindow
    title: qsTr("Variant Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId
    Component.onDestruction: regovar.closeWindow(winId);

    VariantInformation
    {
        id: variantInfoPanel
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
        var mm = regovar.getWindowModels(winId);
        if (mm)
        {
            infoWindow.model = mm;
            title = variantInfoPanel.model.name;
        }
    }
}
