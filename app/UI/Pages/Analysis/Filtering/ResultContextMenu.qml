import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import "../../../Regovar"
import "VariantInformations"
Dialog
{
    id: dialogBox
    title: qsTr("Variant Informations")
    modality: Qt.NonModal
    width: 500
    height: 400

    property alias data: infoPanel.model

    contentItem: VariantInformationsPanel
    {
        id: infoPanel
    }
}
