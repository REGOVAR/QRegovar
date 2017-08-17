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
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (root.model != null)
        {
            resultsTree.model = root.model.results;
            resultsTree.rowHeight = (root.model.samples.length === 1) ? 25 : root.model.samples.length * 18;
        }
    }

    Rectangle
    {
        id: header
        anchors.left: rightPanel.left
        anchors.top: rightPanel.top
        anchors.right: rightPanel.right
        height: 50
        color: Regovar.theme.backgroundColor.alt

        Text
        {
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight

            font.pixelSize: Regovar.theme.font.size.header
            text: root.model.results.loaded + " / " + root.model.results.total
        }

    }




    TreeView
    {
        id: resultsTree
        anchors.fill: rightPanel
        anchors.margins: 10
        anchors.topMargin: 60


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

        // Generic Column component use to display new one when user select a new annotation
        Component
        {
            id: columnComponent
            TableViewColumn { width: 100 }
        }

        // Special column : "RowHead column" with checkbox to select results
        Component
        {
            id: columnComponent_RowHead
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
                                border.color: (modelData == "") ? "transparent" : Regovar.theme.primaryColor.back.dark
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


        // Special column to display sample's name when annnotation of type "sample_array" are displayed
        Component
        {
            id: columnComponent_Samples
            TableViewColumn
            {
                role: "samplesNames"
                title: qsTr("Samples")
                width: 70

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
        }


        onModelChanged:
        {
            // Display selected fields
            if (root.model !== null)
            {
                root.model.resultColumnsChanged.connect(refreshResultColumns);
                refreshResultColumns();
            }

        }

        function refreshResultColumns()
        {
            // Remove old columns
            var position, col;
            for (var idx=resultsTree.columnCount; idx> 0; idx-- )
            {
                col = resultsTree.getColumn(idx-1);
                if (col !== null)
                {
                    console.log("  remove column " + col.role + " at " + (idx-1));
                    // remove columb from UI
                    resultsTree.removeColumn(idx-1);
                }
            }

            // Add columns
            var columns = root.model.resultColumns;
            for (idx=0; idx < columns.length; idx++)
            {
                var uid = columns[idx];
                resultsTree.insertField(uid, idx);
            }
            root.model.results.reset();
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



        function insertField(uid, position, forceRefresh)
        {
            console.log("trying to insert field : " + uid + " at " + position);
            var col;
            var info = root.model.getColumnInfo(uid);
            console.log("  info = " + info);

            if (uid === "_Samples")
            {
                col = columnComponent_Samples.createObject(resultsTree, {"width": info.width});
            }
            else if (uid === "_RowHead")
            {
                col = columnComponent_RowHead.createObject(resultsTree, {"width": info.width});
            }
            else
            {
                var annot = info.annotation;


                // Getting QML column according to the type of the fields
                if (annot.name == "GT")
                    col = columnComponent_GT.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
                else
                    col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
            }

            console.log("  display column " + uid + " at " + position);
            resultsTree.insertColumn(position, col);


            if (forceRefresh)
            {
                root.model.results.reset();
            }
        }
    }
}