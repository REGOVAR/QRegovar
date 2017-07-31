import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"

import "Quickfilter"

Rectangle
{
    id: root


    FontLoader
    {
        id : iconFont
        source: "../../../Icons.ttf"
    }

    SplitView
    {
        anchors.fill: parent


        Rectangle
        {
            id: leftPanel
            color: Regovar.theme.backgroundColor.main
            Layout.maximumWidth: 500
            width: 300

            property string selectedTab: "quickFilters"
            onSelectedTabChanged:
            {
                quickFiltersTab.isSelected = selectedTab === "quickFilters";
                advancedFiltersTab.isSelected = selectedTab === "advancedFilters";
                annotationsTab.isSelected = selectedTab === "annotations";
            }


            Rectangle
            {
                id: leftHeader
                anchors.left: leftPanel.left
                anchors.top: leftPanel.top
                anchors.right: leftPanel.right
                height: 50
                color: Regovar.theme.backgroundColor.alt


                HeaderTabEntry
                {
                    id: quickFiltersTab
                    anchors.top:leftHeader.top
                    anchors.left: leftHeader.left
                    iconText: "F"
                    onIsSelectedChanged: if (isSelected) leftPanel.selectedTab = "quickFilters"
                }
                HeaderTabEntry
                {
                    id: advancedFiltersTab
                    anchors.top:leftHeader.top
                    anchors.left: quickFiltersTab.right
                    iconText: "3"
                    onIsSelectedChanged: if (isSelected) leftPanel.selectedTab = "advancedFilters"
                }
                HeaderTabEntry
                {
                    id: annotationsTab
                    anchors.top:leftHeader.top
                    anchors.left: advancedFiltersTab.right
                    iconText: "o"
                    onIsSelectedChanged: if (isSelected) leftPanel.selectedTab = "annotations"
                    isSelected: true
                }
            }




            QuickFilterPanel
            {
                id: quickFiltersPanel
                anchors.fill: leftPanel
                anchors.margins: 10
                anchors.topMargin: 60
                spacing: 10
                visible: quickFiltersTab.isSelected
            }


            ColumnLayout
            {
                id: advancedFiltersPanel
                anchors.fill: leftPanel
                anchors.margins: 10
                anchors.topMargin: 60
                spacing: 10
                visible: advancedFiltersTab.isSelected


                Text
                {
                    text: qsTr("Saved filters")
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                }
                Text
                {
                    text: qsTr("Current filter")
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                }
                TextArea
                {
                    id: advancedFilterJsonEditor
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: regovar.currentFilteringAnalysis.filter
                }
                RowLayout
                {
                    Layout.fillWidth: true

                    Button
                    {
                        text: qsTr("Clear")
                        onClicked:
                        {
                            regovar.currentFilteringAnalysis.filter = "[\"AND\", []]";
                            regovar.currentFilteringAnalysis.refresh();
                        }
                    }
                    Button
                    {
                        text: qsTr("Apply")
                        onClicked:
                        {
                            regovar.currentFilteringAnalysis.filter = advancedFilterJsonEditor.text;
                            regovar.currentFilteringAnalysis.refresh();
                        }
                    }
                    Button
                    {
                        text: qsTr("Save")
                    }
                }
            }

            ColumnLayout
            {
                id: annotationPanel
                anchors.fill: leftPanel
                anchors.margins: 10
                anchors.topMargin: 60
                spacing: 10
                visible: annotationsTab.isSelected

                Text
                {
                    text: qsTr("Displayed columns")
                    font.pixelSize: Regovar.theme.font.size.header
                    color: Regovar.theme.primaryColor.back.dark
                }

                TreeView
                {
                    id: annotationsSelector
                    model: regovar.currentAnnotations
                    Layout.fillWidth: true
                    Layout.fillHeight: true


                    signal checked(string uid, bool isChecked)
                    onChecked: console.log(uid, isChecked);

                    // Default delegate for all column
                    itemDelegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Regovar.theme.font.size.control
                            text: (styleData.value == undefined) ? "-"  : styleData.value.value
                            elide: Text.ElideRight
                        }
                    }

                    TableViewColumn
                    {
                        role: "name"
                        title: "Name"

                        delegate: Item
                        {
                            CheckBox
                            {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                checked: styleData.value
                                text: (styleData.value == undefined) ? "-"  : styleData.value.value
                                onClicked:
                                {
                                    annotationsSelector.checked(styleData.value.uid, checked);
                                }
                            }
                        }
                    }

                    TableViewColumn
                    {
                        role: "version"
                        title: "Version"
                        width: 80
                    }

                    TableViewColumn {
                        role: "description"
                        title: "Description"
                        width: 250
                    }
                }

                TextField
                {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Search annotation...")
                }
            }
        }


        Rectangle
        {
            id: rightPanel
            color: Regovar.theme.backgroundColor.main


            Rectangle
            {
                id: rightHeader
                anchors.left: rightPanel.left
                anchors.top: rightPanel.top
                anchors.right: rightPanel.right
                height: 50
                color: Regovar.theme.backgroundColor.alt
            }

            Component
            {
                id: columnComponent
                TableViewColumn { width: 100 }
            }

            TreeView
            {
                id: resultsTree
                anchors.fill: rightPanel
                anchors.margins: 10
                anchors.topMargin: 60
                model: regovar.currentFilteringAnalysis

                signal checked(string uid, bool isChecked)
                onChecked: console.log(uid, isChecked);

                Component.onCompleted:
                {
                    // Display selected fields
                    var test = regovar.currentFilteringAnalysis;
                    console.debug("Result tree view ready -> display default columns " +  regovar.currentFilteringAnalysis.fieldsCount())
                    for (var idx=0; idx < regovar.currentFilteringAnalysis.fieldsCount(); idx++)
                    {
                        resultsTree.insertField(regovar.currentFilteringAnalysis.fields[idx], idx);
                    }

                    regovar.currentFilteringAnalysis.refresh();
                }


                function insertField(uid, position)
                {
                    console.log("trying to insert field : " + uid + " at " + position);
                    var annot = regovar.currentAnnotations.getAnnotation(uid);
                    console.log("  annot = " + annot);
                    var col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                    console.log("  col = " + col);
                    position = regovar.currentFilteringAnalysis.setField(uid, true, position) + 1;
                    console.log("  display column " + annot.name + " at " + position);
                    resultsTree.insertColumn(position, col);
                }

                function removeField(uid)
                {
                    console.log("trying to remove field : " + uid);
                    var annot = regovar.currentAnnotations.getAnnotation(uid);
                    console.log("  annot = " + annot);
                    var position, col;
                    for (var idx=0; idx< resultsTree.columnCount; idx++ )
                    {
                        col = resultsTree.getColumn(idx);
                        if (col.role === annot.uid)
                        {
                            console.log("  remove column " + annot.name + " at " + (idx-1));
                            // remove columb from UI
                            resultsTree.removeColumn(idx);
                            // Store fields state and position in the view model
                            regovar.currentFilteringAnalysis.setField(uid, false, idx -1);
                            break;
                        }
                    }
                }

                Connections
                {
                    target: annotationsSelector
                    onChecked:
                    {


                        if (isChecked)
                        {
                            // -1 means "previous position if exists else last position
                            resultsTree.insertField(uid, -1);
                        }
                        else
                        {
                            resultsTree.removeField(uid);
                        }
                    }
                }


                // Default delegate for all column
                itemDelegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.control
                        text: (styleData.value == undefined) ? "-"  : styleData.value.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "id"
                    title: ""
                    width: 30


                    delegate: Item
                    {
                        CheckBox
                        {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: styleData.value
                            text: "" // styleData.value.value
                            onClicked:
                            {
                                resultsTree.checked(styleData.value.uid, checked);
                            }
                        }
                    }
                }
            }
        }
    }
}
