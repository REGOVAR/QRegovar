import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../Dialogs"


Rectangle
{
    id: root
    anchors.fill: parent
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        filterList.model = Qt.binding(function() { return model.filters;});
    }



    property int currentFilterId: -1

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            height: Regovar.theme.font.size.header + 20 // 20 = 2*10 to add spacing top+bottom
            Layout.fillWidth: true
            color: Regovar.theme.backgroundColor.main

            Text
            {
                id: textHeader
                anchors.fill: parent
                anchors.margins: 10

                text: qsTr("Saved filter")
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.dark
                elide: Text.ElideRight
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
            id: filterPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            Column
            {
                x: 10
                y: 5
                width: filterPanel.width - 20
                spacing: 5



                Repeater
                {
                    id: filterList


                    Rectangle
                    {
                        id: filterItemRoot
                        width: filterPanel.width - 20
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
                            width: filterItemRoot.width - 2 // -2 to avoid outstrip border
                            height: Regovar.theme.font.boxSize.normal
                            spacing: 0

                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterItemControl.width/4
                                text: "n"
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Display variants"
                                ToolTip.visible: hovered
                                onClicked: root.loadResult(modelData)
                            }
                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterItemControl.width/4
                                text: "3"
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Load original filter conditions"
                                ToolTip.visible: hovered
                                onClicked: root.loadFilter(modelData)
                            }
                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterItemControl.width/4
                                text: "A"
                                font.family: Regovar.theme.icons.name
                                ToolTip.text: "Edit filter name or description"
                                ToolTip.visible: hovered
                                onClicked: root.editFilter(modelData)
                            }
                            ButtonTab
                            {
                                height: Regovar.theme.font.boxSize.normal
                                Layout.minimumWidth: filterItemControl.width/4
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
                            width: filterItemRoot.width
                            height: 2 * Regovar.theme.font.boxSize.normal
                            color: hovered ? Regovar.theme.secondaryColor.back.light : Regovar.theme.boxColor.back
                            radius: 2

                            border.width: 1
                            border.color: Regovar.theme.boxColor.border

                            GridLayout
                            {
                                anchors.fill: parent
                                anchors.margins: 5
                                columns: 3
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
                                    text: modelData.progress == 1 ? modelData.count : ""
                                    color: Regovar.theme.primaryColor.back.dark
                                    font.family: "monospace"
                                }

                                Rectangle
                                {
                                    Layout.rowSpan: 2
                                    Layout.fillHeight: true
                                    visible: modelData.progress != 1
                                    width: progressLabel.width + 10
                                    color: "transparent"
                                    clip: true

                                    Text
                                    {
                                        id: progressIcon
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        font.pixelSize: Regovar.theme.font.size.header
                                        font.family: Regovar.theme.icons.name
                                        text: "/"
                                        NumberAnimation on rotation
                                        {
                                            duration: 1000
                                            loops: Animation.Infinite
                                            from: 0
                                            to: 360
                                        }
                                    }
                                    Text
                                    {
                                        id: progressLabel
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.bottomMargin: 2

                                        text: qsTr("Saving") + " (" + (modelData.progress * 100) + "%)"
                                        font.pixelSize: Regovar.theme.font.size.small
                                        color: Regovar.theme.primaryColor.back.normal
                                        elide: Text.ElideRight
                                    }
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
                                enabled: modelData.progress == 1
                                onEntered: filterItemRoot.hovered = true
                                onExited:  filterItemRoot.hovered = false

                                onClicked: root.currentFilterId = root.currentFilterId == modelData.id ? -1 : modelData.id
                                onDoubleClicked: { root.loadFilter(modelData); root.currentFilterId = -1;}
                            }
                        }


                    }
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
            height: applyButton.height + 20
            color: "transparent"

            ButtonIcon
            {
                id: applyButton
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: qsTr("Import filter")
                icon: "é"
                enabled: false
            }
        }
    }


    // DIALOGS
    FilterSaveDialog { id: filterSavingFormPopup }
    Connections
    {
        target: model
        onDisplayFilterSavingFormPopup:
        {
            filterSavingFormPopup.saveAdvancedFilter = true;
            filterSavingFormPopup.filterId = -1;
            filterSavingFormPopup.filterName = "";
            filterSavingFormPopup.filterDescription = "";
            filterSavingFormPopup.open();
        }
    }

    QuestionDialog
    {
        id: deleteConfirmDialog
        title: qsTr("Filter deletion")
        onYes: { model.deleteFilter(filterToDelete); filterToDelete = -1 }
        onNo: filterToDelete = -1
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
        filterSavingFormPopup.filterId = filter.id;
        filterSavingFormPopup.filterName = filter.name;
        filterSavingFormPopup.filterDescription = filter.description;
        filterSavingFormPopup.saveAdvancedFilter = false;
        filterSavingFormPopup.open();
    }

    property int filterToDelete
    function deleteFilter(filter)
    {
        var txt = qsTr("Do you confirm the deletion of the \"{}\" filter ?");
        txt = txt.replace("{}", filter.name);
        root.filterToDelete = filter.id;

        deleteConfirmDialog.text = txt;
        deleteConfirmDialog.open();
    }
}
