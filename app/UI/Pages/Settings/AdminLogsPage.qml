import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "../../Regovar"
import "../../Framework"
import "../../Dialogs"

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
            text: qsTr("Regovar server logs")
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
        text: qsTr("Below the list of all events and \"technical\" actions done on the server.")
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


        Item
        {
            width: 500
            ColumnLayout
            {
                anchors.fill: parent
                anchors.rightMargin: 10
                spacing: 10

                TextField
                {
                    id: searchField
                    Layout.fillWidth: true
                    placeholder: qsTr("Filter/Search events")
                    iconLeft: "z"

                    onTextEdited: regovar.eventsManager.technicalEvents.proxy.setFilterString(text)
                    onTextChanged: regovar.eventsManager.technicalEvents.proxy.setFilterString(text)
                }

                TableView
                {
                    id: eventsTable
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: regovar.eventsManager.technicalEvents.proxy

                    TableViewColumn
                    {
                        role: "date"
                        title: qsTr("Date")
                        width: 130
                    }
                    TableViewColumn
                    {
                        role: "targetUI"
                        title: qsTr("Target")
                        width: 75
                    }
                    TableViewColumn
                    {
                        title: "Event"
                        role: "message"
                        width: 500
                        delegate: Item
                        {
                            Text
                            {
                                anchors.leftMargin: 5
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: styleData.textAlignment
                                font.pixelSize: Regovar.theme.font.size.normal
                                text: styleData.value.icon
                                font.family: Regovar.theme.icons.name
                            }
                            Text
                            {
                                anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
                                anchors.rightMargin: 5
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: styleData.textAlignment
                                font.pixelSize: Regovar.theme.font.size.normal
                                text: styleData.value.message
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }


        Item
        {
            ColumnLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 10

                Text
                {
                    Layout.fillWidth: true
                    text: qsTr("TODO: event details panel")
                }

                Item
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                }
            }
        }
    }
}
