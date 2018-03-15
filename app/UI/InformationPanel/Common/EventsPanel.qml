import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        rows: 2
        columns: 2
        rowSpacing: 10
        columnSpacing: 10

        TextField
        {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            iconLeft: "z"
            displayClearButton: true
            placeholder: qsTr("Search events...")
            enabled: false
        }

        TableView
        {
            id: browser
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model

            TableViewColumn
            {
                role: "date"
                title: "Date"
            }
            TableViewColumn
            {
                role: "type"
                title: ""
                width: 50
            }
            TableViewColumn
            {
                role: "message"
                title: "Message"
                width: 300
            }
        }

        ColumnLayout
        {
            id: actionsPanel
            Layout.alignment: Qt.AlignTop
            spacing: 10


            Button
            {
                id: addEvent
                text: qsTr("Add event")
                enabled: false
            }
            Button
            {
                id: editEvent
                text: qsTr("Edit event")
                enabled: false
            }
            Button
            {
                id: deleteEvent
                text: qsTr("Delete event")
                enabled: false
            }
        }
    }
}
