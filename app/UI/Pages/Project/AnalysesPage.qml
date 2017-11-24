import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../../Regovar"
import "../../Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property QtObject model

    property var currentAnalysis: null

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
            anchors.top: header.top
            anchors.left: header.left
            anchors.bottom: header.bottom
            anchors.margins: 10
            font.pixelSize: 22
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            verticalAlignment: Text.AlignVCenter

            text: (model) ? model.name : "?"
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


    SplitView
    {
        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        orientation: Qt.Vertical

        Rectangle
        {
            id: topPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200

            // Help information on this page
            Box
            {
                id: helpInfoBox
                anchors.top : topPanel.top
                anchors.left: topPanel.left
                anchors.right: topPanel.right
                anchors.margins: 10
                height: 30

                visible: Regovar.helpInfoBoxDisplayed
                mainColor: Regovar.theme.frontColor.success
                icon: "k"
                text: qsTr("This page list all analyses that have been done in the current project.")
            }

            Column
            {
                id: actionsPanel
                anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
                anchors.right: topPanel.right
                anchors.margins : 10
                spacing: 10


                Button
                {
                    id: newAnalysis
                    text: qsTr("New")
                    onClicked:  console.log("New analysis")
                }
                Button
                {
                    id: openAnalysis
                    text: qsTr("Open")
                    onClicked:  console.log("Open analysis")
                }
                Button
                {
                    id: playPauseAnalysis
                    text: qsTr("Pause")
                    onClicked:  console.log("Pause/Play analysis")
                }
                Button
                {
                    id: deleteAnalysis
                    text: qsTr("Delete")
                    onClicked:  console.log("Delete analysis")
                }
            }


            TableView
            {
                id: browser
                anchors.left: topPanel.left
                anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : header.bottom
                anchors.right: actionsPanel.left
                anchors.bottom: topPanel.bottom
                anchors.margins: 10
                model: (root.model) ? root.model.analyses : []


                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        text: styleData.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "type"
                    title: "Type"
                }
                TableViewColumn
                {
                    role: "name"
                    title: "Name"
                }
                TableViewColumn
                {
                    role: "status"
                    title: "Status"
                }
                TableViewColumn
                {
                    role: "lastUpdate"
                    title: "Date"
                }
                TableViewColumn
                {
                    role: "comment"
                    title: "Comment"
                    width: 400
                }


                onCurrentRowChanged:
                {
                    displayCurrentAnalysisPreview(root.model.analyses[currentRow]);
                }
            }
        } // end topPanel

        Rectangle
        {
            id: bottomPanel
            width: root.width
            color: Regovar.theme.backgroundColor.main
            Layout.minimumHeight: 200

            Rectangle
            {
                id: helpPanel
                anchors.fill: parent
                anchors.margins: 10

                color: "transparent"

                visible: root.currentAnalysis

                Text
                {
                    text: qsTr("Select an analysis in the table above.\nThe preview of this analysis will be display here.")
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.normal
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                Text
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top : parent.top
                    text: "Ä"
                    font.family: Regovar.theme.icons.name
                    font.pixelSize: 30
                    color: Regovar.theme.primaryColor.back.normal

                    NumberAnimation on anchors.topMargin
                    {
                        duration: 2000
                        loops: Animation.Infinite
                        from: 30
                        to: 0
                        easing.type: Easing.SineCurve
                    }
                }
            } // end helpPanel

        } // end bottomPanel
    } // end SplitView


    function displayCurrentAnalysisPreview(analysis)
    {
        root.currentAnalysis = analysis;
    }
}
