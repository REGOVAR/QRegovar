import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"

import "Quickfilter"
import org.regovar 1.0

Rectangle
{
    id: root

    property FilteringAnalysis model

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
                    text: root.model.filter
                }
                RowLayout
                {
                    Layout.fillWidth: true

                    Button
                    {
                        text: qsTr("Clear")
                        onClicked:
                        {
                            root.model.filter = "[\"AND\", []]";
                            root.model.refresh();
                        }
                    }
                    Button
                    {
                        text: qsTr("Apply")
                        onClicked:
                        {
                            root.model.filter = advancedFilterJsonEditor.text;
                            root.model.refresh();
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
                    model: root.model.annotations
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
                            text: (styleData.value == undefined || styleData.value.value == null) ? "-"  : styleData.value.value
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
                                checked: false // styleData.value.isChecked
                                text: (styleData.value == undefined || styleData.value.value == undefined) ? "-"  : styleData.value.value
                                onClicked:
                                {
                                    var test = styleData.value
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




            TreeView
            {
                id: resultsTree
                anchors.fill: rightPanel
                anchors.margins: 10
                anchors.topMargin: 60
                model: root.model.results
                rowHeight: (root.model.samples.length === 1) ? 25 : root.model.samples.length * 18

                signal checked(string uid, bool isChecked)
                onChecked: console.log(uid, isChecked);


                Connections
                {
                    target: annotationsSelector
                    onChecked:
                    {


                        if (isChecked)
                        {
                            // -1 means "previous position if exists else last position
                            resultsTree.insertField(uid, -1, true);
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
                        text: (styleData.value == undefined || styleData.value.value == null) ? "-"  : styleData.value.value
                        elide: Text.ElideRight
                    }
                }

                // First column with checkbox to select results
                TableViewColumn
                {
                    role: "id"
                    title: ""
                    width: 30


                    delegate: Item
                    {
                        anchors.margins: 0
                        CheckBox
                        {
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false // styleData.value
                            text: "" // styleData.value.value
                            onClicked:
                            {
                                resultsTree.checked(styleData.value.uid, checked);
                            }
                        }
                    }
                }

                // Special column to display sample's name when annnotation of type "sample_array" are displayed
                TableViewColumn
                {
                    role: "samplesNames"
                    title: qsTr("Samples")
                    width: 70
                    visible: root.model.sampleColumnDisplayed
                    delegate: Item
                    {
                        ColumnLayout
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            spacing: 1
                            Repeater
                            {
                                model: root.model.samples
                                Text
                                {
                                    height: 12
                                    verticalAlignment: Text.AlignVCenter
                                    text : modelData
                                    font.pixelSize: 10
                                    color: "grey"
                                }
                            }
                        }
                    }
                }

                // Generic Column component use to display new one when user select a new annotation
                Component
                {
                    id: columnComponent
                    TableViewColumn { width: 100 }
                }

                // Custom Column component for GT annotations
                Component
                {
                    id: columnComponent_GT
                    TableViewColumn
                    {
                        width: 30

                        delegate: Item
                        {
                            ColumnLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                spacing: 1
                                Repeater
                                {

                                    model: styleData.value.values



                                    Rectangle
                                    {
                                        width: 12
                                        height: 12
                                        border.width: 1
                                        border.color: (modelData == "") ? "transparent" : Regovar.theme.boxColor.border
                                        color: (modelData == "") ? "transparent" : Regovar.theme.boxColor.back



                                        Rectangle
                                        {
                                            anchors.fill: parent
                                            anchors.margins: 1
                                            anchors.rightMargin: 6
                                            color: (modelData == 1 || modelData == 3) ? Regovar.theme.primaryColor.back.dark : "transparent"
                                        }
                                        Rectangle
                                        {
                                            anchors.fill: parent
                                            anchors.margins: 1
                                            anchors.leftMargin: 6
                                            color: (modelData == 0) ? "transparent" : ((modelData == 3) ? Regovar.theme.primaryColor.back.light : Regovar.theme.primaryColor.back.dark)
                                        }
                                        Text
                                        {
                                            text : "?"
                                            font.pixelSize: 10
                                            anchors.centerIn: parent
                                            visible: modelData == ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Component.onCompleted:
                {
                    // Display selected fields
                    console.debug("Result tree view ready -> display default columns " +  root.model.fieldsCount())
                    for (var idx=0; idx < root.model.fieldsCount(); idx++)
                    {
                        resultsTree.insertField(root.model.fields[idx], idx);
                    }
                    root.model.results.refresh();

                }


                function insertField(uid, position, forceRefresh)
                {
                    console.log("trying to insert field : " + uid + " at " + position);
                    var annot = root.model.annotations.getAnnotation(uid);
                    console.log("  annot = " + annot);

                    // Getting QML column according to the type of the fields
                    var col;
                    if (annot.name == "GT")
                        col = columnComponent_GT.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                    else
                        col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                    console.log("  col = " + col);
                    position = root.model.setField(uid, true, position) + 2;
                    console.log("  display column " + annot.name + " at " + position);
                    position = Math.min(position, resultsTree.columnCount)
                    resultsTree.insertColumn(position, col);

                    if (forceRefresh)
                    {
                        root.model.results.refresh();
                    }
                }

                function removeField(uid)
                {
                    console.log("trying to remove field : " + uid);
                    var annot = root.model.annotations.getAnnotation(uid);
                    console.log("  annot = " + annot);
                    var position, col;
                    for (var idx=0; idx< resultsTree.columnCount; idx++ )
                    {
                        col = resultsTree.getColumn(idx);
                        if (col.role === annot.uid)
                        {
                            console.log("  remove column " + annot.name + " at " + (idx-2));
                            // remove columb from UI
                            resultsTree.removeColumn(idx);
                            // Store fields state and position in the view model
                            root.model.setField(uid, false, idx -2);
                            break;
                        }
                    }
                }
            }
        }
    }
}
