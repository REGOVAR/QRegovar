import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../Regovar"
import "../Framework"
import "../MainMenu"


Rectangle
{
    id: root

    Component.onCompleted:
    {
        // regovar.currentAnnotationsTreeView.refresh();
        regovar.currentFilteringAnalysis.refresh();
    }

    FontLoader
    {
        id : iconFont
        source: "../Icons.ttf"
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





            ColumnLayout
            {
                id: quickFiltersPanel
                anchors.fill: leftPanel
                anchors.margins: 10
                anchors.topMargin: 60
                spacing: 10
                visible: quickFiltersTab.isSelected

                Text
                {
                    text: qsTr("Quick filters")
                }
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
                            text: styleData.value.value
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
                                text: styleData.value.value
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



                Connections
                {
                    target: annotationsSelector
                    onChecked:
                    {
                        var annot = regovar.currentAnnotations.getAnnotation(uid);
                        if (isChecked)
                        {
                            var col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                            console.log("Add new resultsTree columns")
                            resultsTree.addColumn(col);
                        }
                        else
                        {
                            for (var idx=0; idx< resultsTree.columnCount; idx++ )
                            {
                                var col = resultsTree.getColumn(idx);
                                if (col.role === annot.uid)
                                {
                                    resultsTree.removeColumn(idx);
                                    break;
                                }
                            }
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
                        text: styleData.value.value
                        elide: Text.ElideRight
                    }
                }

                TableViewColumn
                {
                    role: "id"
                    title: ""



                    delegate: Item
                    {
                        CheckBox
                        {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            checked: styleData.value
                            text: styleData.value.value
                            onClicked:
                            {
                                resultsTree.checked(styleData.value.uid, checked);
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "816ce7a58b6918652399342e46143386"
                    title: "chr"
                }

                TableViewColumn {
                    role: "0ec9783c0c626c928005f05956cb3d7b"
                    title: "pos"
                }

                TableViewColumn {
                    role: "de2b02e8a7f3c77cf55efd18e0832f22"
                    title: "ref"
                }

                TableViewColumn {
                    role: "ab1e6b068bd1618d0422a462df93f28b"
                    title: "alt"
                }

                TableViewColumn
                {
                    role: "66b71b223a449d2369e7d58ec0c7cd5d"
                    title: "samples"

                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value["8"]
                            elide: Text.ElideRight
                        }
                    }
                }

                TableViewColumn {
                    role: "6cde5e77baebcc9d98c40a720f6c1b82"
                    title: "count"
                }

                TableViewColumn
                {
                    role: "b33e172643f14920cee93d25daaa3c7b"
                    title: "GT"

                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value["8"]
                            elide: Text.ElideRight
                        }
                    }
                }

                TableViewColumn
                {
                    role: "3ee42adc14f878158deeb74e16131cf5"
                    title: "DP"

                    delegate: Item
                    {
                        Text
                        {
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: styleData.textAlignment
                            font.pixelSize: Regovar.theme.font.size.control
                            text: styleData.value["8"]
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
