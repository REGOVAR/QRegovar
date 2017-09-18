import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"

Item
{
    id: root



    Button
    {
        anchors.centerIn: parent
        text: "Information (cf. poster)"
        font.pointSize: 24
        onClicked: sampleDialog.open()
    }


    SelectSamplesDialog
    {
        id: sampleDialog
    }
}
