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
        text:  qsTr("This step is optional.\nYou can add custom attributes to your samples. Then it will allow you to do some 'set' conditions in your filter.\nBy example, you can add an attribute 'sex' to your samples and then filter variants by sample that are 'Female'...")
        wrapMode: Text.WordWrap
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.normal
    }

    Text
    {
        anchors.centerIn: parent
        text: qsTr("TODO")
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.frontColor.normal
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
                text: qsTr("Samples attributes")
                font.pixelSize: Regovar.theme.font.size.normal
                color: Regovar.theme.frontColor.normal
            }

            TableView
            {
                id: samplesList
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: regovar.newFilteringAnalysis.samples
                selectionMode: SelectionMode.NoSelection

                TableViewColumn { title: qsTr("Sample"); role: "name" }


                Connections
                {
                    target: regovar.newFilteringAnalysis
                    onAttributesChanged:
                    {
                        samplesList.addColumn()
                    }
                }

                TableViewColumn
                {
                    title: qsTr("Sex")
                    role: "sex"
                    delegate: Item
                    {
                        TextFieldForm
                        {
                            anchors.fill: parent
                            text: index
                        }
                    }
                }
                TableViewColumn
                {
                    title: qsTr("Index")
                    role: "index"
                    delegate: Item
                    {
                        TextFieldForm
                        {
                            anchors.fill: parent
                            text: index
                        }
                    }
                }
            }
        }

        Column
        {
            id: actionColumn
            anchors.top: parent.top
            anchors.topMargin: header.height + 10
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
                onClicked: { newAttributeDialog.open(); }
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
            }
            Button
            {
                id: remButton
                text: qsTr("Remove attribute")
                Component.onCompleted: actionColumn.maxWidth = Math.max(actionColumn.maxWidth, width)
                onClicked:
                {
                    // Get list of objects to remove
                    var attributes = []
                    samplesList.selection.forEach( function(rowIndex)
                    {
                        attributes = attributes.concat(regovar.newFilteringAnalysis.samples[rowIndex]);
                    });
                    regovar.newFilteringAnalysis.removeAttribute(attributes);
                }
            }
        }
    }

    NewAttributeDialog
    {
        id: newAttributeDialog
    }

}
