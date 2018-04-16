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
        onTextEdited: subjectsTable.model.setFilterString(text)
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
            delegate: RowLayout
            {
                anchors.left: parent.left
                anchors.leftMargin: 5
                spacing: 10

                ButtonInline
                {
                    iconTxt: "z"
                    text: ""
                    onClicked: regovar.subjectsManager.openSubject(model.id)
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
        subjectsTable.enabled = count>0;
        searchField.enabled = count>0;

        if (count>0)
        {
            subjectsTable.model = data.subjects.proxy;
            label.text = count + " subjects.";
        }
        else
        {
            subjectsTable.model = null;
            label.text = "No subject.";
        }
    }
}
