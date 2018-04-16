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



    TextField
    {
        id: searchField
        Layout.fillWidth: true
        iconLeft: "z"
        displayClearButton: true
        placeholder: qsTr("Quick filter...")
        onTextEdited: genesTable.model.setFilterString(text)
    }



    TableView
    {
        id: genesTable
        Layout.fillWidth: true
        Layout.fillHeight: true

        TableViewColumn
        {
            role: "id"
            title: "Gene"
        }
//        TableViewColumn
//        {
//            role: "panel"
//            title: "Panel"
//            width: 300
//        }
    }


    Text
    {
        id: label
        Layout.fillWidth: true
        font.pixelSize: Regovar.theme.font.size.small
        horizontalAlignment: Text.AlignRight
    }

    function updateFromModel(data)
    {
        if (!data) return;

        var count = data.genes.rowCount();
        genesTable.enabled = count>0;
        searchField.enabled = count>0;

        if (count>0)
        {
            genesTable.model = data.genes.proxy;
            label.text = count + " genes.";
        }
        else
        {
            genesTable.model = null;
            label.text = "No gene.";
        }
    }
}
