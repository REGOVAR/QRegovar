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
        onTextEdited: pehnotypesTable.model.setFilterString(text)
    }



    TableView
    {
        id: pehnotypesTable
        Layout.fillWidth: true
        Layout.fillHeight: true

        TableViewColumn
        {
            role: "label"
            title: "Phenotype"
            width: 300

            delegate: RowLayout
            {
                anchors.left: parent.left
                anchors.leftMargin: 5
                spacing: 10

                ButtonInline
                {
                    iconTxt: "z"
                    text: ""
                    onClicked: regovar.getPhenotypeInfo(model.id)
                }
                Text
                {
                    Layout.fillWidth: true
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    text: styleData.value
                }
            }
        }
        TableViewColumn
        {
            role: "qualifiers"
            title: "Qualifiers"
            width: 300
        }
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

        var count =  data.phenotypes.rowCount();
        pehnotypesTable.enabled = count>0;
        searchField.enabled = count>0;

        if (count>0)
        {
            pehnotypesTable.model = data.phenotypes.proxy;
            label.text = count + " phenotypes.";
        }
        else
        {
            pehnotypesTable.model = null;
            label.text = "No phenotype.";
        }
    }
}
