import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Dialogs"


GenericScreen
{
    id: root

    readyForNext: true


    // Help information on this page
    Box
    {
        id: helpInfoBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 30

        visible: Regovar.helpInfoBoxDisplayed
        icon: "k"
        text: qsTr("This step is optional.\nYou can add custom attributes to your samples. Then it will allow you to do some 'set' conditions in your filter.\nBy example, you can add an attribute 'sex' to your samples and then filter variants by sample that are 'Female'...")
    }

    RowLayout
    {
        anchors.top: Regovar.helpInfoBoxDisplayed ? helpInfoBox.bottom : parent.top
        anchors.topMargin: Regovar.helpInfoBoxDisplayed ? 10 : 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        TableView
        {
            id: samplesAttributesTable
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: regovar.analysesManager.newFiltering.samples

            TableViewColumn { title: qsTr("Sample"); role: "name" }


            Connections
            {
                target: regovar.analysesManager.newFiltering
                onAttributesChanged: samplesAttributesTable.refreshColumns()
            }

            // Special column to display sample's attribute
            Component
            {
                id: columnComponent_attribute

                TableViewColumn
                {
                    width: 100
                    property var attribute

                    delegate: Item
                    {
                        TableViewTextField
                        {
                            id: textField
                            anchors.fill: parent
                            text: attribute.getValue(styleData.value.id)
                            onTextEdited: attribute.setValue(styleData.value.id, text)
                        }
                    }
                }
            }



            function refreshColumns()
            {
                // Remove old columns (except the first one with samples names
                var position, col;
                for (var idx=samplesAttributesTable.columnCount; idx> 1; idx-- )
                {
                    col = samplesAttributesTable.getColumn(idx-1);
                    if (col !== null)
                    {
                        // remove columb from UI
                        samplesAttributesTable.removeColumn(idx-1);
                    }
                }

                // Add columns
                for (idx=0; idx < regovar.analysesManager.newFiltering.attributes.length; idx++)
                {
                    var attribute = regovar.analysesManager.newFiltering.attributes[idx];
                    col = columnComponent_attribute.createObject(samplesAttributesTable, {"attribute": attribute, "title": attribute.name});
                    samplesAttributesTable.insertColumn(idx+1, col);
                }
            }
        }

        Column
        {
            id: actionColumn
            Layout.alignment: Qt.AlignTop
            spacing: 10

            property real maxWidth: 0
            onMaxWidthChanged:
            {
                addButton.width = maxWidth;
                remButton.width = maxWidth;
            }

            Button
            {
                id: addButton
                text: qsTr("Add attribute")
                onClicked: newAttributeDialog.open()
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: remButton
                text: qsTr("Remove attribute")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked: remAttributeDialog.open()
            }
        }
    }

    NewAttributeDialog
    {
        id: newAttributeDialog
    }

    DeleteAttributeDialog
    {
        id: remAttributeDialog
    }
}
