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
            onTextEdited: subjectsTable.model.setFilterString(text)
        }
    }



    TableView
    {
        id: subjectsTable
        Layout.fillWidth: true
        Layout.fillHeight: true

        TableViewColumn
        {
            role: "identifier"
            title: qsTr("Identifier")
            width: 75
        }
        TableViewColumn
        {
            role: "lastname"
            title: qsTr("Lastname")
        }
        TableViewColumn
        {
            role: "firstname"
            title: qsTr("Firstname")
        }
        TableViewColumn
        {
            role: "sex"
            title: qsTr("Sex")
            width: 75
        }
        TableViewColumn
        {
            role: "dateOfBirth"
            title: qsTr("Date of birth")
            width: 100
        }
        TableViewColumn
        {
            role: "comment"
            title: qsTr("Comment")
        }
    }

    function updateFromModel(data)
    {
        if (!data) return;

        var count = data.genes.rowCount();
        subjectsTable.enabled = count>0;
        searchField.enabled = count>0;

        if (count>0)
        {
            subjectsTable.model = data.subjects.proxy;
            label.text = count + " subjects have this phenotype.";
        }
        else
        {
            subjectsTable.model = null;
            label.text = "No subject have the phenotype.";
        }
    }
}
