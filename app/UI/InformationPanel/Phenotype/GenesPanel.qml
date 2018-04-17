import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/InformationPanel/Common"

Item
{
    id: root
    property var model
    onModelChanged: updateFromModel(model)
    Component.onCompleted: updateFromModel(model)

    ColumnLayout
    {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        visible: false
        enabled: false

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
        }

        Text
        {
            id: label
            Layout.fillWidth: true
            font.pixelSize: Regovar.theme.font.size.small
            horizontalAlignment: Text.AlignRight
        }
    }

    Text
    {
        id: emptyMessage
        anchors.fill: parent
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        text: qsTr("No gene")
        color: Regovar.theme.primaryColor.back.normal
        font.pixelSize: Regovar.theme.font.size.header
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    function updateFromModel(data)
    {
        if (!data) return;
        var count = data.subjects.rowCount();

        if (count>0)
        {
            content.visible = true;
            content.enabled = true;
            emptyMessage.visible = false;
            genesTable.model = data.genes.proxy;
            label.text = count + " genes.";
        }
        else
        {
            content.visible = false;
            content.enabled = false;
            emptyMessage.visible = true;
            genesTable.model = null;
        }
    }
}
