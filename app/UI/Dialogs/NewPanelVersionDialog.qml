import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../Regovar"
import "../Framework"

Dialog
{
    id: root
    modality: Qt.WindowModal
    title: qsTr("Create new panel")

    width: 600
    height: 400

    property Panel model
    onModelChanged: if (model) updateViewFromModel()

    property int currentStep: 1

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
            iconText: "q"
            title: qsTr("Editing panel")
            text: ""
        }


        GridLayout
        {
            id: step1
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10
            visible: root.currentStep == 1

            rows: 5
            columns: 2
            columnSpacing: 30
            rowSpacing: 10


            Text
            {
                text: qsTr("Name*")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
                font.bold: true
            }
            TextField
            {
                id: panelNameField
                Layout.fillWidth: true
                placeholder: qsTr("Name of the panel")
                text: regovar.panelsManager.newPanel.name
            }

            Text
            {
                text: qsTr("Owner")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: ownerField
                Layout.fillWidth: true
                placeholder: qsTr("Full name of the panel's owner or referring.")
                text: regovar.panelsManager.newPanel.owner
            }

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: qsTr("Description")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextArea
            {
                id: descriptionField
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: regovar.panelsManager.newPanel.description
            }

            Text
            {
                text: qsTr("Shared")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            CheckBox
            {
                id: sharedField
                Layout.fillWidth: true
                text: qsTr("Check it if you want to share this panel with the community.")
                checked: regovar.panelsManager.newPanel.shared
            }
        }

        ColumnLayout
        {
            id: step2
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10
            visible: root.currentStep == 2
            spacing: 10

            RowLayout
            {
                Text
                {
                    text: qsTr("New version*")
                    color: Regovar.theme.primaryColor.back.dark
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    verticalAlignment: Text.AlignVCenter
                    height: 35
                    font.bold: true
                }
                TextField
                {
                    id: versionField
                    Layout.fillWidth: true
                    placeholder: qsTr("Version name")
                    text: regovar.panelsManager.newPanel.version
                }
            }


            RowLayout
            {

                spacing: 10

                TableView
                {
                    id: panelEntriesTable
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    model: regovar.panelsManager.newPanel.entries

                    TableViewColumn
                    {
                        title: qsTr("Label")
                        width: 200
                        role: "label"

                    }
                    TableViewColumn
                    {
                        role: "details"
                        title: qsTr("Details")
                        width: 400
                    }
                }

                Column
                {
                    Layout.alignment: Qt.AlignTop
                    spacing: 10

                    Button
                    {
                        text: qsTr("Add entry")
                        onClicked:
                        {
                            newPanelEntryDialog.x = root.x + 50;
                            newPanelEntryDialog.y = root.y + 50;
                            newPanelEntryDialog.open()
                        }
                        enabled: !newPanelEntryDialog.visible
                    }
                    Button
                    {
                        text: qsTr("Remove entry")
                        onClicked: removeSelectedEntry()
                        enabled: !newPanelEntryDialog.visible
                    }
                    Button
                    {
                        text: qsTr("Remove all")
                        onClicked: removeAllEntries()
                        enabled: !newPanelEntryDialog.visible
                    }
                }
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
                text: root.currentStep == 1 ? qsTr("Add new version") : qsTr("Edit panel infos")
                enabled: panelNameField.text.trim() != "" && !newPanelEntryDialog.visible
                onClicked:
                {
                    if (step1.visible)
                    {
                        root.currentStep = 2;
                    }
                    else
                    {
                        root.currentStep = 1;
                    }
                }
            }

            Button
            {
                text: qsTr("Cancel")
                onClicked: root.close()
                enabled: !newPanelEntryDialog.visible
            }


            Button
            {
                text: qsTr("Save")
                onClicked:
                {
                    loadingIndicator.visible = true;
                    root.commit();
                }
            }
        }

        Rectangle
        {
            id: loadingIndicator
            anchors.fill : parent
            color: Regovar.theme.backgroundColor.alt
            visible: false

            BusyIndicator
            {
                anchors.centerIn: parent
            }
        }
    }


    NewPanelEntryDialog { id: newPanelEntryDialog }

    Connections
    {
        target: regovar.panelsManager
        onCommitNewPanelDone:
        {
            loadingIndicator.visible = false;
            if (success) root.close();
        }
    }

    function removeSelectedEntry()
    {
        regovar.panelsManager.newPanel.removeEntryAt(panelEntriesTable.currentRow);
    }
    function removeAllEntries()
    {
        regovar.panelsManager.newPanel.removeAllEntries();
    }

    function reset(newModel)
    {
        root.currentStep = 1;
        root.model = null;
        header.text = "";
        if (newModel)
        {
            root.model = newModel;

            var headVersion = model.getVersion(model.versionsIds[0]);
            header.text = qsTr("Edit panel's informations and/or add new versions.");
            //header.text += "\n" + qsTr("ID") + ": " + model.panelId;
            header.text += "\n\n" + qsTr("Current name") + ": " + model.name;
            header.text += "\n" + qsTr("Head version") + ": " + headVersion.version;
        }
    }

    function updateViewFromModel()
    {
        panelNameField.text = model.name;
        versionField.text = "v" + (model.versionsIds.length + 1)
        ownerField.text = model.owner;
        descriptionField.text = model.description;
        sharedField.checked = model.shared;
        regovar.panelsManager.newPanel.reset();

        // Init new version with entries of the current head version
        var headVersion = model.getVersion(model.versionsIds[0]);
        for(var idx in headVersion.entries)
            regovar.panelsManager.newPanel.addEntry(headVersion.entries[idx]);
    }

    function commit()
    {
        regovar.panelsManager.newPanel.panelId = model.panelId;
        regovar.panelsManager.newPanel.name = panelNameField.text;
        regovar.panelsManager.newPanel.version = versionField.text;
        regovar.panelsManager.newPanel.owner = ownerField.text;
        regovar.panelsManager.newPanel.description = descriptionField.text;
        regovar.panelsManager.newPanel.shared = sharedField.checked;
        regovar.panelsManager.commitNewPanel();
    }
}