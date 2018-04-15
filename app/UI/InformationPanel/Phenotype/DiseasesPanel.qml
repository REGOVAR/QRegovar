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
            Layout.fillWidth: true
            iconLeft: "z"
            displayClearButton: true
            placeholder: qsTr("Quick filter...")
            onTextEdited: diseasesTable.model.setFilterString(text)
        }
    }



    TableView
    {
        id: diseasesTable
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

        var count =  data.diseases.rowCount();
        diseasesTable.enabled = count>0;
        searchField.enabled = count>0;

        if (count>0)
        {
            diseasesTable.model = data.diseases.proxy;
            label.text = "The phenotype have been found in " + count + " diseases.";
        }
        else
        {
            diseasesTable.model = null;
            label.text = "The phenotype have not been found in any disease.";
        }
    }
}
