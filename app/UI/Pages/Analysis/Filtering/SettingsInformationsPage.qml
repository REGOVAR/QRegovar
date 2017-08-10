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
            text: root.model.name
            font.pixelSize: 22
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter
        }
    }


    GridLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10

        rows: 4
        columns: 2
        columnSpacing: 30
        rowSpacing: 10


        Text
        {
            text: qsTr("Informations")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.header
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }


        Rectangle
        {
            height: 60
            Layout.fillWidth: true

            color: Regovar.theme.boxColor.back
            border.color: Regovar.theme.boxColor.border
            border.width: 1

            GridLayout
            {
                anchors.fill: parent
                anchors.margins: 10

                rows: 2
                columns: 3
                rowSpacing: 10

                Text
                {
                    text: qsTr("Referencial")
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    text: qsTr("Status")
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    text: qsTr("Update")
                    color: Regovar.theme.frontColor.normal
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                }
                Text
                {
                    Layout.fillWidth: true
                    text: "Hg19" // root.model.refName
                    color: Regovar.theme.frontColor.disable
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    Layout.fillWidth: true
                    text: root.model.status
                    color: Regovar.theme.frontColor.disable
                    verticalAlignment: Text.AlignVCenter
                }
                Text
                {
                    Layout.fillWidth: true
                    text: root.model.lastUpdate.toString()
                    color: Regovar.theme.frontColor.disable
                }
            }
        }




        Text
        {
            text: qsTr("Name")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.header
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextField
        {
            Layout.fillWidth: true
            text: root.model.name
            placeholderText: qsTr("The name of the analysis")
        }

        Text
        {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            text: qsTr("Comment")
            color: Regovar.theme.primaryColor.back.dark
            font.pixelSize: Regovar.theme.font.size.header
            font.family: Regovar.theme.font.familly
            verticalAlignment: Text.AlignVCenter
            height: 35
        }
        TextArea
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: root.model.comment
        }
    }

}
