import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"
import "../../../Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model

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
            font.pixelSize: 20
            font.weight: Font.Black
        }
    }

    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 10
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        mainColor: Regovar.theme.frontColor.success
        icon: "k"
        text: qsTr("Statistics about your variants and quality scores from DepthOfCoverage.")
    }

    Text
    {
       text: "Statistics & Quality"
       font.pointSize: 24
       anchors.centerIn: parent
    }
}
