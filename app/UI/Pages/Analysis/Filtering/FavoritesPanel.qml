import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"


Rectangle
{
    id: root
    anchors.fill: parent
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        filterList.model = model.filters;
    }

    property int currentFilterId: -1

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        Text
        {
            text: qsTr("Saved filter")
            height: Regovar.theme.font.boxSize.header
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.header
            color: Regovar.theme.primaryColor.back.dark
            elide: Text.ElideRight
        }

        ScrollView
        {
            id: filterPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                width: filterPanel.width
                spacing: 5



                Repeater
                {
                    id: filterList


                    Rectangle
                    {
                        id: filterItemRoot
                        width: filterPanel.width
                        height: filterItemContent.height
                        color: "transparent"
                        property bool hovered: false
                        property bool expanded: root.currentFilterId == modelData.id
                        onExpandedChanged:
                        {
                            if (expanded)
                            {
                                filterItemRoot.height = filterItemControl.height + filterItemContent.height;
                            }
                            else
                            {
                                filterItemRoot.height = filterItemContent.height;
                            }
                        }

                        Behavior on height
                        {
                            NumberAnimation
                            {
                                duration: 150
                            }
                        }

                        RowLayout
                        {
                            anchors.bottom: filterItemRoot.bottom
                            anchors.bottomMargin: 5

                            id: filterItemControl
                            width: filterPanel.width
                            height: Regovar.theme.font.boxSize.normal
                            spacing: 0

                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterPanel.width/4
                                baseColor: Regovar.theme.backgroundColor.alt
                                text: "n"
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Display variants"
                                ToolTip.visible: hovered
                                onClicked: root.loadResult(modelData)
                            }
                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterPanel.width/4
                                baseColor: Regovar.theme.backgroundColor.alt
                                text: "3"
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Load original filter conditions"
                                ToolTip.visible: hovered
                                onClicked: root.loadFilter(modelData)
                            }
                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterPanel.width/4
                                baseColor: Regovar.theme.backgroundColor.alt
                                text: "A"
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Edit filter name or description"
                                ToolTip.visible: hovered
                                onClicked: root.editFilter(modelData)
                            }
                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterPanel.width/4
                                baseColor: Regovar.theme.backgroundColor.alt
                                text: "="
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Delete filter"
                                ToolTip.visible: hovered
                                onClicked: root.deleteFilter(modelData)
                            }
                        }

                        Rectangle
                        {
                            id: filterItemContent
                            width: filterPanel.width
                            height: 2 * Regovar.theme.font.boxSize.normal
                            color: hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.backgroundColor.alt
                            radius: 2

                            border.width: 1
                            border.color: Regovar.theme.boxColor.border

                            GridLayout
                            {
                                anchors.fill: parent
                                anchors.margins: 5
                                columns: 2
                                rows:1
                                columnSpacing: 5
                                rowSpacing: 0

                                Text
                                {
                                    id: filterItemName
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: Regovar.theme.primaryColor.back.dark
                                    elide: Text.ElideRight
                                    font.bold: true
                                }
                                Text
                                {
                                    id: filterItemCount
                                    text: modelData.count
                                    color: Regovar.theme.primaryColor.back.dark
                                    font.family: "monospace"
                                }

                                Text
                                {
                                    id: filterItemDesc
                                    Layout.fillWidth: true
                                    Layout.columnSpan: 2
                                    text: modelData.description ? modelData.description : "-"
                                    font.pixelSize: Regovar.theme.font.size.small
                                    color: Regovar.theme.primaryColor.back.normal
                                    elide: Text.ElideRight
                                }
                            }
                            MouseArea
                            {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: filterItemRoot.hovered = true
                                onExited: filterItemRoot.hovered = false
                                // cursorShape: Qt.PointingHandCursor

                                onClicked:  root.currentFilterId = root.currentFilterId == modelData.id ? -1 : modelData.id
                                onDoubleClicked: { root.loadFilter(modelData); root.currentFilterId = -1;}
                            }
                        }


                    }
                }
            }
        }
        Button
        {
            anchors.right: parent.right
            text: qsTr("Import")
            enabled: false
        }
    }
    function loadResult(filter)
    {
        console.log("Load result " + filter.name + "(" + filter.id + ")");
        var sf = ["AND", ["IN", "variant", ["filter", filter.id]]];
        // Update advance filter tree with saved filter
        root.model.loadFilter(sf);
        // Get Results
        root.model.results.applyFilter(sf);
        // Update Title
        root.model.currentFilterName = filter.name;
    }
    function loadFilter(filter)
    {
        console.log("Load filter " + filter.name + "(" + filter.id + ")");
        // Update advance filter tree with saved filter
        root.model.loadFilter(filter.filter);
        // Get Results
        root.model.results.applyFilter(filter.filter);
        // Update Title
        root.model.currentFilterName = filter.name;
    }
    function editFilter(filter)
    {
        console.log("Load filter " + filter.name + "(" + filter.id + ")");
        //root.model.loadFilter(filter);
    }
    function deleteFilter(filter)
    {
        console.log("Load filter " + filter.name + "(" + filter.id + ")");
        //root.model.loadFilter(filter);
    }
}
