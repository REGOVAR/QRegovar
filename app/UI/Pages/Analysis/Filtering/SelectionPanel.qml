import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property int selectionCount: 0
    property FilteringAnalysis model
    onModelChanged:
    {
        if (model)
        {
            // We set manually the model to be able to call *after* the reset of the control
            // otherwise with binding, this order may not be respect, and init of UI is not good.
            console.log("reset all quick filter panel")
            for (var i = 0; i < container.children.length; ++i)
            {
                var item = container.children[i];
                if (item.objectName === "qf")
                {
                    item.model = model;
                    item.reset();
                }
            }

            model.onSelectedResultsChanged.connect(updateSelectionCount);
            updateSelectionCount();
        }
    }
    Component.onDestruction: model.onSelectedResultsChanged.disconnect(updateSelectionCount);

    // QML binding not working well, to do it manually
    function updateSelectionCount()
    {
        if (model) selectionCount = model.selectedResults.length;
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            height: Regovar.theme.font.size.header + 20 // 20 = 2*10 to add spacing top+bottom
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.main

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                Text
                {
                    id: textHeader
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: qsTr("Selected variants")
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                    elide: Text.ElideRight
                }
                Text
                {
                    id: countHeader
                    Layout.fillHeight: true

                    text: selectionCount
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: fixedFont
                    color: Regovar.theme.primaryColor.back.dark
                    elide: Text.ElideRight
                }
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Regovar.theme.boxColor.border
            }
        }



        Rectangle
        {
            id: container
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.main

            Column
            {
                anchors.top : container.top
                anchors.left: container.left
                anchors.right: container.right
                anchors.margins: 10
                spacing: 10

                // Info if no variant selected
                Box
                {
                    width: parent.width
                    visible: selectionCount === 0
                    icon: "k"
                    text: qsTr("No variant selected.")
                }
                // Button to generate report or export
                Button
                {
                    id: displayButton
                    width: parent.width
                    visible: selectionCount > 0
                    text: qsTr("Display selection.")
                    onClicked: model.results.applySelection()
                }

                // Info about number of variant selected
                Box
                {
                    width: parent.width
                    visible: selectionCount > 0
                    icon: "k"
                    text: selectionCount + " " + qsTr("variant selected.\nTo export them in a file or generate a report, select the action in the list below and click on the export button.")
                }

                ComboBox
                {
                    id: exporterCombo
                    width: parent.width
                    visible: selectionCount > 0
                    model: ["CSV Export", "Hugodims Report"]
                }

                // Button to generate report or export
                ButtonIcon
                {
                    id: exportButton
                    visible: selectionCount > 0
                    text: qsTr("Export selection.")
                    iconTxt: "_"
                    onClicked: console.log("Export !")
                }
            }
        }
    }
}
