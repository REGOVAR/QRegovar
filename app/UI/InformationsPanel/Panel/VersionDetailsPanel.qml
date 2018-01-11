import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.regovar 1.0

import "../../Regovar"
import "../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property var model
    onModelChanged:  if (model) { updateFromModel(model); }


    ColumnLayout
    {
        id: step2
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout
        {
            Text
            {
                text: qsTr("Version")
                color: Regovar.theme.primaryColor.back.dark
                font.pixelSize: Regovar.theme.font.size.normal
                font.family: Regovar.theme.font.family
                verticalAlignment: Text.AlignVCenter
                height: 35
            }

            ComboBox
            {
                id: versionsCombo
                Layout.fillWidth: true
                onCurrentIndexChanged: updateEntriesList(currentIndex)
            }
        }


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
    }

    function updateFromModel(newModel)
    {
        if (newModel)
        {
            var versionList = [];
            for (var idx in newModel.versionsIds)
            {
                var version = newModel.getVersion(newModel.versionsIds[idx]);
                versionList.push(version.version);
            }
            versionsCombo.model = versionList;
            updateEntriesList(0);
        }
    }

    function updateEntriesList(idx)
    {
        if (model && idx >=0 && idx < model.versionsIds.length)
        {
            var versionId = model.versionsIds[idx];
            var version = model.getVersion(versionId);
            if (version)
            {
                panelEntriesTable.model = version.entries;
            }
            else
            {
                panelEntriesTable.model = null;
                console.log("What the Hell ?");
            }
        }
        else
        {
            panelEntriesTable.model = null;
        }
    }



}
