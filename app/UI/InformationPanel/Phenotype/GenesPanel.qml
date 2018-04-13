import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/InformationPanel/Common"


ColumnLayout
{
    id: root
    property var model
    onModelChanged: updateFromModel(model)
    Component.onCompleted: updateFromModel(model)
    anchors.margins: 10


    RowLayout
    {
        Layout.fillWidth: true
        spacing: 10

        Text
        {
            id: label
        }

        TextField
        {
            id: searchField
            iconLeft: "z"
            displayClearButton: true
            placeholder: qsTr("Quick filter...")
            onTextEdited: genesTable.model.setFilterString(text)
        }
    }



    TableView
    {
        id: genesTable
        Layout.fillWidth: true
        Layout.fillHeight: true

        TableViewColumn
        {
            role: "id"
            title: "Id"
            width: 75
        }
        TableViewColumn
        {
            role: "label"
            title: "Disease"
            width: 300
        }
        TableViewColumn
        {
            role: "qualifiers"
            title: "Qualifiers"
            width: 300
        }
    }

    function updateFromModel(data)
    {
        if (!data) return;

        genesTable.enabled = data.diseases.length>0;
        searchField.enabled = data.diseases.length>0;

        if (data.genes.length>0)
        {
            genesTable.model = data.genes.proxy;
            label.text = "The phenotype is linked to " + data.genes.length + " genes.";
        }
        else
        {
            genesTable.model = null;
            label.text = "The phenotype is not linked to any gene.";
        }
    }
}
