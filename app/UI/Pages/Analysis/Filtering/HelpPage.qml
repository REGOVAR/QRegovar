import QtQuick 2.7
import QtQuick.Layouts 1.3
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        nameLabel.text = model.name;
    }

    Rectangle
    {
        id: header
        anchors.left: root.left
        anchors.top: root.top
        anchors.right: root.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.fill: header
            anchors.margins: 10
            //text: model.name
            font.pixelSize: 20
            font.weight: Font.Black
        }

        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
        }
    }

    Text
    {
        anchors.centerIn: parent
        text: qsTr("Documentation regarding filtering analyses")
        color: Regovar.theme.primaryColor.back.dark
        font.pixelSize: Regovar.theme.font.size.header
        font.family: Regovar.theme.font.familly
        verticalAlignment: Text.AlignVCenter
        height: 35
    }

}
