import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"


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
            spacing: 10

            ComboBox
            {
                id: versionsCombo
                onCurrentIndexChanged: updateEntriesList(currentIndex)
            }

            TextField
            {
                Layout.fillWidth: true

                property string formerSearch: ""
                iconLeft: "z"
                displayClearButton: true
                placeholder: qsTr("Filter entries ...")
                onTextChanged:
                {
                    if (panelEntriesTable.model !== null && formerSearch !== text)
                    {
                        panelEntriesTable.model.setFilterString(text);
                        formerSearch = text;
                    }
                }
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
            for (var idx=0; idx < newModel.versions.rowCount(); idx++)
            {
                var version = newModel.versions.getAt(idx);
                versionList.push(version.name);
            }
            versionsCombo.model = versionList;
            updateEntriesList(0);
        }
    }

    function updateEntriesList(idx)
    {
        if (model && idx >=0 && idx < model.versions.rowCount())
        {
            var version = model.versions.getAt(idx);
            if (version)
            {
                panelEntriesTable.model = version.entries.proxy;
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
