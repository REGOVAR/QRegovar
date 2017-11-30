import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import "../Regovar"
import "../Framework"

Dialog
{
    id: root
    modality: Qt.WindowModal
    title: qsTr("Create new panel")

    width: 600
    height: 400

    property int currentStep: 1
    onVisibleChanged: reset()


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
            title: qsTr("New panel")
            text: qsTr("A panel is a set of regions of interest. Those regions are defined by a chromosome and a position interval.\nYou can also quickly define a region by a gene, a phenotype or disease existing in the database (and which are already linked to a region).")
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
                id: nameField
                Layout.fillWidth: true
                placeholderText: qsTr("Name of the panel")
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
                placeholderText: qsTr("Full name of the panel's owner or referring.")
            }

            Text
            {
                text: qsTr("Version")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.familly
                verticalAlignment: Text.AlignVCenter
                height: 35
            }
            TextField
            {
                id: versionField
                Layout.fillWidth: true
                placeholderText: qsTr("Optional name of this version. (let empty for automatic incrementation number).")
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
                id: commentField
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                checked: false
            }
        }

        RowLayout
        {
            id: step2
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top
            anchors.margins: 10
            visible: root.currentStep == 2

            spacing: 10

            TableView
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                TableViewColumn
                {
                    role: "label"
                    title: qsTr("Label")
                    width: 200
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
                id: previousButton
                text: qsTr("< Previous")
                visible: root.currentStep == 2
                onClicked: root.currentStep = 1
                enabled: !newPanelEntryDialog.visible
            }

            Button
            {
                text: qsTr("Cancel")
                onClicked: root.close()
                enabled: !newPanelEntryDialog.visible
            }

            Button
            {
                text: root.currentStep == 1 ? qsTr("Next >") : qsTr("Finish")
                enabled: nameField.text.trim() != "" && !newPanelEntryDialog.visible
                onClicked:
                {
                    if (step1.visible)
                    {
                        root.currentStep = 2;
                    }
                    else
                    {
                        if (nameField.text.trim() != "")
                        {
                            loadingIndicator.visible = true;
                            regovar.projectsManager.newProject(nameField.text.trim(), commentField.text);
                        }
                    }
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
        onPanelCreationDone:
        {
            loadingIndicator.visible = false;
            if (success) root.close();
        }
    }


    function reset()
    {
        if (root.visible)
        {
            nameField.text = "";
            commentField.text = "";
        }
    }

    function removeSelectedEntry()
    {

    }

}
