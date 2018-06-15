import QtQuick 2.9
import QtQuick.Window 2.3
import "qrc:/qml/Regovar"
import "qrc:/qml/Pages/Admin"

Window
{
    id: fileInfoDialog
    title: qsTr("Server tasks")
    visible: false
    modality: Qt.NonModal
    width: 700
    height: 500
    minimumHeight : 300
    minimumWidth : 300

    property string winId

    ServerTasks
    {
        id: serverRTPanel
        anchors.fill: parent
    }
}
