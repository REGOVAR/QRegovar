import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: root
    modality: Qt.WindowModal
    title: eventModel ? qsTr("Edit event") : qsTr("Create new event")

    width: 600
    height: 400

    property bool editMode: false
    property EventsListModel listModel
    property Event eventModel
    onVisibleChanged:
    {
        if (visible)
        {
            reset();
        }
    }


    contentItem: Rectangle
    {
        anchors.fill : parent
        color: Regovar.theme.backgroundColor.alt

        DialogHeader
        {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            iconText: "H"
            title: eventModel ? qsTr("Edit event") : qsTr("Create new event")
            text: qsTr("Use custom events to enrich the history with important facts.")
        }

        GridLayout
        {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10

            rows: 3
            columns: 2
            columnSpacing: 30
            rowSpacing: 10

            Text
            {
                text: qsTr("Message*")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
                font.bold: true
            }
            TextField
            {
                id: messageField
                Layout.fillWidth: true
                placeholder: qsTr("Main message")
            }

            Text
            {
                text: qsTr("Date")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: dateField
                Layout.fillWidth: true
                placeholder: qsTr("YYYY-MM-DD [HH:MM]")
            }

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: qsTr("Details")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextArea
            {
                id: detailsField
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: regovar.panelsManager.newPanel.description
            }
        }

        Row
        {
            id: footer
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10

            height: Regovar.theme.font.boxSize.normal
            spacing: 10

            Button
            {
                text: qsTr("Cancel")
                onClicked: root.close()
            }

            Button
            {
                text: qsTr("Save")
                onClicked:
                {
                    root.commit();
                    root.close();
                }
            }
        }
    }


    function removeSelectedEntry()
    {
        regovar.panelsManager.newPanel.removeEntryAt(panelEntriesTable.currentRow);
    }

    function reset(event)
    {
        if (event)
        {
            eventModel = event;
            messageField.text = event.message;
            dateField.text = event.date;
            detailsField.text = event.details;
        }
        else
        {
            eventModel = null;
            messageField.text = "";
            dateField.text = "";
            detailsField.text = "";
        }
    }

    function commit()
    {
        if (root.eventModel)
        {
            regovar.eventsManager.updateEvent(eventId, messageField.text, dateField.text, detailsField.text);
        }
        else
        {
            listModel.newEvent(messageField.text, regovar.dateFromString(dateField.text), detailsField.text);
        }
    }

}
