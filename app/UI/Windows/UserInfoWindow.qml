import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/InformationPanel/User"

Window
{
    id: userInfoDialog
    title: qsTr("User Information")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property int winId

    UserInformation
    {
        id: userInfoPanel
        anchors.fill: parent
    }

    Connections
    {
        target: regovar
        onUserInformationSearching: { userInfoPanel.reset(); userInfoDialog.show(); }
    }

    function initFromCpp(cppWinId)
    {
        winId = cppWinId;
        userInfoPanel.model = regovar.getWindowModels(winId);
        title = userInfoPanel.model.name;
    }
}
