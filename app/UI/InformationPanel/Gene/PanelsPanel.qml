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
            onTextEdited: panelsTable.model.setFilterString(text)
        }

        TableView
        {
            id: panelsTable
            Layout.fillWidth: true
            Layout.fillHeight: true

            TableViewColumn
            {
                role: "name"
                title: "Name"
                delegate: RowLayout
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    spacing: 10

                    ButtonInline
                    {
                        iconTxt: "z"
                        text: ""
                        onClicked: regovar.getPanelInfo(model.id)
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
                role: "comment"
                title: "Comment"
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
    }

    Text
    {
        id: emptyMessage
        anchors.fill: parent
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        text: qsTr("No panel contains this gene")
        color: Regovar.theme.primaryColor.back.normal
        font.pixelSize: Regovar.theme.font.size.header
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    function updateFromModel(data)
    {
        if (!data) return;
        var count =  data.panels.rowCount();

        if (count>0)
        {
            content.visible = true;
            content.enabled = true;
            emptyMessage.visible = false;
            panelsTable.model = data.panels.proxy;
            label.text = count + " panels.";
        }
        else
        {
            content.visible = false;
            content.enabled = false;
            emptyMessage.visible = true;
            panelsTable.model = null;
        }
    }
}
