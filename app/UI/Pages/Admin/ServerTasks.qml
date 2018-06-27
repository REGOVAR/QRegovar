import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main


    property QtObject model

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
            font.pixelSize: Regovar.theme.font.size.title
            font.weight: Font.Black
            color: Regovar.theme.primaryColor.back.dark
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Regovar server tasks in progress")
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
        icon: "k"
        text: qsTr("Below the list of all events and \"technical\" actions done on the server.")
    }


    ColumnLayout
    {
        anchors.top : header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.margins: 10
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? helpInfoBox.height + 20 : 10

        spacing: 10

        TextField
        {
            id: searchField
            Layout.fillWidth: true
            placeholder: qsTr("Filter/Search tasks")
            iconLeft: "z"
            displayClearButton: true

            onTextEdited: regovar.serverTasks.proxy.setFilterString(text)
            onTextChanged: regovar.serverTasks.proxy.setFilterString(text)
        }

        TableView
        {
            id: eventsTable
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: regovar.serverTasks.proxy

            TableViewColumn
            {
                role: "status"
                title: qsTr("Status")
                delegate: Item
                {
                    RowLayout
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        spacing: 10

                        enabled: styleData.value.status !== "done"

                        // TODO
//                        ButtonInline
//                        {
//                            text: ""
//                            iconTxt: styleData.value.status === "running" ? "y" : "x"
//                            ToolTip.text: styleData.value.status ==="running" ? qsTr("Pause task") : qsTr("Resume task")
//                            ToolTip.visible: hovered
//                            onClicked: regovar.serverTasks.pause(styleData.value.id);
//                        }

//                        ButtonInline
//                        {
//                            text: ""
//                            iconTxt: "h"
//                            ToolTip.text: qsTr("Cancel task")
//                            ToolTip.visible: hovered
//                            onClicked: regovar.serverTasks.cancel(styleData.value.id);
//                        }
                        Text
                        {
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.status
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            TableViewColumn
            {
                role: "progress"
                title: qsTr("Progress")
                delegate: Item
                {

                    Rectangle
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        border.width: 1
                        border.color: Regovar.theme.boxColor.border
                        color: Regovar.theme.boxColor.back
                        width: 100
                        height: 10

                        Rectangle
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 1
                            height: 8
                            color: Regovar.theme.secondaryColor.back.normal

                            width: 98 * styleData.value
                        }
                    }
                }
            }

            TableViewColumn
            {
                role: "label"
                title: qsTr("Task")
                width: 500
                delegate: Item
                {
                    RowLayout
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        spacing: 10

                        // TODO
//                        ButtonInline
//                        {
//                            text: ""
//                            iconTxt: "z"
//                            ToolTip.text: qsTr("Display details")
//                            ToolTip.visible: hovered
//                            onClicked: regovar.serverTasks.open(styleData.value.id);
//                        }
                        Text
                        {
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.normal
                            text: styleData.value.label
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
