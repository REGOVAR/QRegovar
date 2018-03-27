import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/Pages/Analysis/Filtering/SelectionTools"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        // We set manually the model to be able to call *after* the reset of the control
        // otherwise with binding, this order may not be respect, and init of UI is not good.
        console.log("reset all quick filter panel")
        for (var i = 0; i < container.children.length; ++i)
        {
            var item = container.children[i];
            if (item.objectName == "qf")
            {
                item.model = model;
                item.reset();
            }
        }
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

                    text: "13"
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.header
                    font.family: "monospace"
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
                color: Regovar.theme.primaryColor.back.light
            }
        }


        ScrollView
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                id: container
                Rectangle { width: root.width; height: 5; color: "transparent" }
                ExportTool
                {
                    id: exportTool
                    width: root.width
                    onIsExpandedChanged: if (isExpanded) reportTool.isExpanded = false;
                }
                ReportTool
                {
                    id: reportTool
                    width: root.width
                    onIsExpandedChanged: if (isExpanded) exportTool.isExpanded = false;
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: exportButton.height + 20
            color: "transparent"

            Row
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                spacing: 10
                ButtonIcon
                {
                    id: exportButton
                    text: qsTr("Export")
                    iconTxt: "_"
                    enabled: exportTool.isExpanded
                    onClicked: regovar.toolsManager.exporters[exportTool.currentIndex].run(model.id)
                }

                ButtonIcon
                {
                    id: reportButton
                    text: qsTr("Report")
                    iconTxt: "Y"
                    enabled: reportTool.isExpanded
                    onClicked: regovar.toolsManager.reporters[reportTool.currentIndex].run(model.id)
                }
            }
        }
    }
}
