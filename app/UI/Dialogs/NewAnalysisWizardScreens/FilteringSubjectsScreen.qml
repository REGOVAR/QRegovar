import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "../../Regovar"
import "../../Framework"
import "../../Dialogs"


GenericScreen
{
    id: root

    readyForNext: true

    Text
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text:  qsTr("This step is optional.\nYou can link samples to subjects. It will be easier to retrieve their samples and analyses later.")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

    RowLayout
    {
        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10


        ColumnLayout
        {
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text
            {
                id: tableTitle
                text: qsTr("Samples subjects")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.normal
            }

            TableView
            {
                id: samplesAttributesTable
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.newFilteringAnalysis.samples

                TableViewColumn { title: qsTr("Sample"); role: "name" }
                TableViewColumn { title: qsTr("Identifier"); role: "identifier" }
                TableViewColumn { title: qsTr("Firstname"); role: "firstname" }
                TableViewColumn { title: qsTr("Lastname"); role: "lastname" }
                TableViewColumn { title: qsTr("Sex"); role: "name" }
                TableViewColumn { title: qsTr("Family Number"); role: "name" }
                TableViewColumn { title: qsTr("Date of birth"); role: "name" }


                Connections
                {
                    target: regovar.newFilteringAnalysis
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
                    for (idx=0; idx < regovar.newFilteringAnalysis.attributes.length; idx++)
                    {
                        var attribute = regovar.newFilteringAnalysis.attributes[idx];
                        col = columnComponent_attribute.createObject(samplesAttributesTable, {"attribute": attribute, "title": attribute.name});
                        samplesAttributesTable.insertColumn(idx+1, col);
                    }
                }
            }
        }

        Column
        {
            id: actionColumn
            anchors.top: parent.top
            anchors.topMargin:  tableTitle.height + 10
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
                text: qsTr("Find subject")
                onClicked: { sampleSelector.reset(); sampleSelector.open(); }
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: remButton
                text: qsTr("New subject")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked:
                {
                    // Get list of objects to remove
                    var samples= []
                    samplesList.selection.forEach( function(rowIndex)
                    {
                        samples = samples.concat(regovar.newFilteringAnalysis.samples[rowIndex]);
                    });
                    regovar.newFilteringAnalysis.removeSamples(samples);
                    trioActivated.checked = regovar.newFilteringAnalysis.samples.length == 3;
                }
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
