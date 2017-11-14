import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0
import "../../../Regovar"
import "../../../Framework"
import "VariantInformations"

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
        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tristique eu lorem sit amet viverra. Vivamus vitae fringilla nibh. Mauris tempor neque eu mauris tristique consequat. Curabitur dui enim, tempor ut quam vel, sagittis tempus diam. Praesent eu erat ante.")
    }


    SplitView
    {
        id: row
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        Rectangle
        {
            id: leftPanel
            color: "transparent"
            Layout.fillWidth: true
            Layout.minimumWidth: 300
            // height is sized by colomn content
            onHeightChanged: row.height = Math.max(height, row.height)
            clip: true

            Text
            {
                id: leftPanelHeader
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.header
                text: qsTr("Variant selection")
            }

            Rectangle
            {
                anchors.top: leftPanelHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: Regovar.theme.font.boxSize.normal
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            TableView
            {
                id: lefPanel

            }
        }

        Rectangle
        {
            id: rightPanel
            color: "transparent"
            // height is sized by colomn content
            onHeightChanged: row.height = Math.max(height, row.height)
            Layout.minimumWidth: 350
            clip: true

            Text
            {
                id: rightPanelHeader
                anchors.left: parent.left
                anchors.leftMargin: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                height: Regovar.theme.font.boxSize.header
                text: qsTr("Last subjects")
            }

            Rectangle
            {
                anchors.top: rightPanelHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Regovar.theme.font.boxSize.normal
                height: 1
                color: Regovar.theme.primaryColor.back.normal
            }

            VariantInformationsPanel
            {
                id: variantInfo

            }
        }

    }
}
