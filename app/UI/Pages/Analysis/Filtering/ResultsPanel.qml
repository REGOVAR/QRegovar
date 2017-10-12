import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.regovar 1.0
import QtQml.Models 2.2

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
            anchors.bottom: header.bottom
            anchors.top: header.top
            anchors.left: header.left
            anchors.margins: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight

            font.pixelSize: Regovar.theme.font.size.header
            text: ( root.model != null) ?  Regovar.formatBigNumber(root.model.results.total) + " " + ((root.model.results.total > 1) ? qsTr("results") : qsTr("result")) : ""
        }
        ConnectionStatus
        {
            anchors.top: header.top
            anchors.right: header.right
            anchors.bottom: header.bottom
            anchors.margins: 5
            anchors.rightMargin: 10
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

        onHeaderMoved: root.model.saveHeaderPosition(header, newPosition)
        onHeaderResized: root.model.saveHeaderWidth(header, newSize)

        // Default delegate for all column
        itemDelegate: Item
        {
            Text
            {
                anchors.leftMargin: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.normal
                elide: Text.ElideRight
                text: styleData.value ? styleData.value : "-"
            }
        }

        MouseArea
        {
            anchors.fill: parent
            anchors.topMargin: 24 // 24 = Header height (see UI/Framework/TreeView.qml)

            acceptedButtons: Qt.RightButton
            onClicked: resultsTree.openResultContextMenu(mouse.x, mouse.y + 24) // compense header's margin
        }


        // Generic Column component use to display new one when user select a new annotation
        Component
        {
            id: columnComponent
            TableViewColumn { width: 100 }
        }

        // Number formating
        Component
        {
            id: columnComponent_number
            TableViewColumn
            {
                width: 100
                delegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        elide: Text.ElideRight
                        font.family: "monospace"
                        horizontalAlignment: Text.AlignRight
                        text: styleData.value ? Regovar.formatBigNumber(styleData.value) : "-"
                    }
                }
            }
        }

        // List formating
        Component
        {
            id: columnComponent_list
            TableViewColumn
            {
                width: 100
                delegate: Item
                {
                    Text
                    {
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignLeft
                        text: styleData.value ? resultsTree.listToVal(styleData.value) : "-"
                    }
                }
            }
        }

        // Sequence formating
        Component
        {
            id: columnComponent_sequence
            TableViewColumn
            {
                width: 100
                delegate: Item
                {
                    TextEdit
                    {
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal


                        textFormat: Text.RichText
                        readOnly: true
                        selectByMouse: true
                        selectByKeyboard: true

                        font.family: "monospace"
                        text: styleData.value ? Regovar.formatSequence(styleData.value) : "-"
                    }
                }
            }
        }

        // Boolean formating
        Component
        {
            id: columnComponent_bool
            TableViewColumn
            {
                width: 30
                delegate: Item
                {
                    TextEdit
                    {
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Regovar.theme.font.size.normal
                        textFormat: Text.RichText
                        readOnly: true

                        font.family: Regovar.theme.icons.name
                        horizontalAlignment: Text.AlignHCenter
                        text: (styleData.value) ? "n" : "h"
                        color: (styleData.value) ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.lighter(Regovar.theme.frontColor.normal )
                    }
                }
            }
        }

        // Special column : "RowHead column" with checkbox to select results
        Component
        {
            id: columnComponent_RowHead
            TableViewColumn
            {
                role: "id"
                title: ""
                width: 60


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

                            model: resultsTree.mapToList(styleData.value)



                            Rectangle
                            {
                                width: 12
                                height: 12
                                border.width: 1
                                border.color: (model.value == "") ? "transparent" : Regovar.theme.primaryColor.back.dark
                                color: (model.value == "") ? "transparent" : Regovar.theme.boxColor.back



                                Rectangle
                                {
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    anchors.rightMargin: 6
                                    color: (model.value == 1 || model.value == 3) ? Regovar.theme.primaryColor.back.dark : "transparent"
                                }
                                Rectangle
                                {
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    anchors.leftMargin: 6
                                    color: (model.value == 0) ? "transparent" : ((model.value == 3) ? Regovar.theme.primaryColor.back.light : Regovar.theme.primaryColor.back.dark)
                                }
                                Text
                                {
                                    text : "?"
                                    font.pixelSize: 10
                                    anchors.centerIn: parent
                                    visible: model.value == ""
                                }
                            }
                        }
                    }
                }
            }
        }
        // Custom Column Component for DP Annotations
        Component
        {
            id: columnComponent_DP
            TableViewColumn
            {
                width: 60

                delegate: Item
                {
                    ColumnLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        spacing: 1
                        Repeater
                        {

                            model: resultsTree.mapToList(styleData.value)


                            Text
                            {
                                height: 12
                                font.pixelSize: 12
                                text: (model) ? model.value : "-"
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
                                text : modelData.name
                                font.pixelSize: 10
                                color: Regovar.theme.frontColor.disable
                            }
                        }
                    }
                }
            }
        }

        Component
        {
            id: listModel
            ListModel { }
        }


        onModelChanged:
        {
            // Display selected fields
            if (root.model !== null)
            {
                root.model.onContextualVariantInformationReady.connect(onOpenResultContextMenuFinish);
                root.model.resultColumnsChanged.connect(refreshResultColumns);
                refreshResultColumns();
            }

        }

        function mapToList(json)
        {
            var newModel = listModel.createObject(resultsTree);

            var l = root.model.samples.length;
            // /!\ It's important to respect the same order as in the root.model.samples list.
            for (var idx=0; idx<l; idx++)
            {
                var sid = root.model.samples[idx].id;
                newModel.append({ "id": sid, "value" : json[sid]});
            }

            return newModel;
        }

        function listToVal(json)
        {
            var result = "";
            for (var idx=0; idx<json.length; idx++)
            {
                result += ", " + json[idx];
            }
            return result.substring(2, result.length);
        }

        function openResultContextMenu(x, y)
        {
            // 0- retrieve row index
            var index = resultsTree.indexAt(x, y)
            if (!index.valid)
            {
                console.log("error : unable to get valid result's treeview row index.");
                return;
            }

            // 1- display context menu as "loading indicator"
            resultContextMenu.open();
            resultContextMenu.x = x;
            resultContextMenu.y = y + resultContextMenu.height / 2;

            // 2- retrieve variant id
            var variantId = resultsTree.model.data(index, Qt.UserRole +1); // enum value of ResultsTreeModel.ColumnRole.id
            if (variantId.indexOf("_") >= 0)
            {
                variantId = variantId.uid.split("_")[0];
            }

            // 3- get variant information
            root.model.getVariantInfo(variantId);

            // 4-... call to server are asynch.
            // See connection to the signal model.onContextualVariantInformationReady

        }
        function onOpenResultContextMenuFinish(json)
        {
            resultContextMenu.data = json;

            // 4- wait answers

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
            //root.model.results.reset();
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
            if (root.model == undefined || root.model == null)
            {
                return;
            }

            console.log("trying to insert field : " + uid + " at " + position);
            var col;
            var info = root.model.getColumnInfo(uid);
            console.log("  info = " + info);

            if (uid === "_Samples")
            {
                col = columnComponent_Samples.createObject(resultsTree);
            }
            else if (uid === "_RowHead")
            {
                col = columnComponent_RowHead.createObject(resultsTree);
            }
            else
            {
                var annot = info.annotation;


                // Getting QML column according to the type of the fields
                if (annot.name == "GT")
                    col = columnComponent_GT.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                else if (annot.name == "DP")
                    col = columnComponent_DP.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                else
                {
                    if (annot.type == "int")
                        col = columnComponent_number.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
                    else if (annot.type == "bool")
                        col = columnComponent_bool.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
                    else if (annot.type == "sequence")
                        col = columnComponent_sequence.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
                    else if (annot.type == "list")
                        col = columnComponent_list.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
                    else
                        col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
                }
            }

            console.log("  display column " + uid + " at " + position);
            resultsTree.insertColumn(position, col);


            if (forceRefresh)
            {
                root.model.results.reset();
            }
        }
    }


    ResultContextMenu
    {
        id: resultContextMenu
        visible: false
    }

    Rectangle
    {
        id: busyIndicator
        anchors.fill: rightPanel
        anchors.margins: 10
        anchors.topMargin: 60

        color: "#aaffffff"
        visible: !regovar.newFilteringAnalysis.isLoading

        MouseArea
        {
            anchors.fill: parent
        }

        BusyIndicator
        {
            anchors.centerIn: parent
        }
    }

}
