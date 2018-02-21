import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0
import QtQml.Models 2.2

import "../../../Regovar"
import "../../../Framework"
import "../../../MainMenu"
import "../../../InformationPanel/Variant"

import Regovar.Core 1.0



TreeView
{
    id: resultsTree
    //smooth: false
    //layer.enabled: false

    signal checked(string id, bool isChecked)
    onChecked: analysis.setVariantSelection(id, isChecked);

    property FilteringAnalysis analysis
    onAnalysisChanged:
    {
        if (analysis)
        {
            analysis.displayedAnnotationsChanged.connect(refreshResultColumns);
            refreshResultColumns();
        }
    }
    Component.onDestruction:
    {
        analysis.displayedAnnotationsChanged.disconnect(refreshResultColumns);
    }


    sortIndicatorVisible: true
    onSortIndicatorColumnChanged: analysis.setFilterOrder(sortIndicatorColumn, sortIndicatorOrder)
    onSortIndicatorOrderChanged: analysis.setFilterOrder(sortIndicatorColumn, sortIndicatorOrder)
    onHeaderMoved: analysis.saveHeaderPosition(oldPosition, newPosition)
    onHeaderResized: analysis.saveHeaderWidth(headerPosition, newSize)



    MouseArea
    {
        anchors.fill: parent
        anchors.topMargin: Regovar.theme.font.boxSize.normal // = Header height (see UI/Framework/TreeView.qml)

        acceptedButtons: Qt.RightButton
        onClicked: resultsTree.openVariantInfoDialog(mouse.x, mouse.y + Regovar.theme.font.boxSize.normal) // compense header's margin
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
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    font.family: "monospace"
                    text: styleData.value ? styleData.value : "-"
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
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    text: styleData.value ? styleData.value : "-"
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
                Text
                {
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.normal
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText

                    font.family: "monospace"
                    text: styleData.value ? styleData.value : "-"

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
                Text
                {
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.icons.name
                    horizontalAlignment: Text.AlignLeft
                    text: styleData.value ? styleData.value : ""
                    color: styleData.value ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.lighter(Regovar.theme.frontColor.normal )
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
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
            role: "is_selected"
            title: ""
            width: 60


//            delegate: Item
//            {
//                //anchors.margins: 0
//                CheckBox
//                {
//                    anchors.left: parent.left
//                    anchors.leftMargin: 5
//                    anchors.verticalCenter: parent.verticalCenter
//                    checked: Boolean(styleData.value)
//                    text: "" // resultsTree.model.data(styleData.index, Qt.UserRole +1)
//                    onClicked:
//                    {
//                        var id = resultsTree.model.data(styleData.index, Qt.UserRole +1);
//                        resultsTree.checked(id, checked);
//                    }
//                }
//            }
        }
    }

    // Custom Column component for GT annotations
    Component
    {
        id: columnComponent_SampleArrayGT
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
                            // display :
                            // None => "?"
                            // -50  => "ERR"
                            // -1   => "-"
                            // 0    => ref/ref
                            // 1    => alt/alt
                            // 2    => ref/alt
                            // 3    => alt1/alt2

                            width: 12
                            height: 12
                            border.width: gt_valid(model.value) ? 1 : 0
                            border.color: gt_valid(model.value) ? Regovar.theme.primaryColor.back.dark : "transparent"
                            color: gt_valid(model.value) ? Regovar.theme.boxColor.back : "transparent"

                            function gt_valid(value)
                            {
                                // !model.value || model.value == -50 || model.value == -1
                                return value !== undefined && value !== null && value !== "" && value >=0;
                            }


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
                                color: !gt_valid(model.value) ||  model.value == 0 ? "transparent" : model.value == 3 ? Regovar.theme.primaryColor.back.light : Regovar.theme.primaryColor.back.dark
                            }
                            Text
                            {
                                text : model.value == -50 ? "ERR" : model.value == -1 ? "-" : model.value == "" ? "?" : "? (" + model.value + ")"
                                font.pixelSize: 10
                                anchors.centerIn: parent
                                visible: !gt_valid(model.value)
                                elide: Text.ElideRight
                                renderType: Text.NativeRendering
                                textFormat: Text.PlainText
                            }
                        }
                    }
                }
            }
        }
    }
    // Custom Column Component for generic type Annotations
    Component
    {
        id: columnComponent_SampleArrayString
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

                        model: styleData.value ? resultsTree.mapToList(styleData.value) : null


                        Text
                        {
                            height: 12
                            font.pixelSize: 12
                            text: (model) ? String(model.value) : "-"
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                            textFormat: Text.PlainText
                        }
                    }
                }
            }
        }
    }
    // Custom Column Component for SampleArray Enum Annotations
    Component
    {
        id: columnComponent_SampleArrayEnum
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

                        model: styleData.value ? resultsTree.mapToList(styleData.value) : null
                        Text
                        {
                            Layout.fillWidth: true
                            height: 12
                            font.pixelSize: 12
                            text: String(model.value)
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                            textFormat: Text.PlainText
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
                        model: analysis.samples
                        Text
                        {
                            height: 12
                            verticalAlignment: Text.AlignVCenter
                            text : modelData.name
                            font.pixelSize: 10
                            color: Regovar.theme.frontColor.disable
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                            textFormat: Text.PlainText
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





    function mapToList(json)
    {

        var newModel = listModel.createObject(resultsTree);

        var l = analysis.samples.length;
        // /!\ It's important to respect the same order as in the analysis.samples list.
        for (var idx=0; idx<l; idx++)
        {
            var sid = analysis.samples[idx].id;
            var data = json[sid];
            if (typeof(data) == "object" && data !== null)
            {
                if ("length" in data)
                {
                    var datares = ""
                    for (var idx2=0; idx2<data.length; idx2++)
                    {
                        datares += data[idx2] + ", ";
                    }
                    data = datares;
                }
            }

            newModel.append({ "id": sid, "value" : data});
        }

        return newModel;
    }



    function openVariantInfoDialog(x, y)
    {
        // 0- retrieve row index
        var index = resultsTree.indexAt(x, y)
        if (!index.valid)
        {
            console.log("error : unable to get valid result's treeview row index.");
            return;
        }

        // 2- retrieve variant id
        var variantId = resultsTree.model.data(index, Qt.UserRole +1); // enum value of ResultsTreeModel.ColumnRole.id
        if (variantId.indexOf("_") >= 0)
        {
            variantId = variantId.split("_")[0];
        }

        // 3- get variant information in a stand alone info dialog
        regovar.getVariantInfo(analysis.refId, variantId, analysis.id);
    }



    function refreshResultColumns()
    {
        if (analysis === undefined || analysis === null)
        {
            return;
        }

        resultsTree.rowHeight = (resultsTree.analysis.samplesByRow === 1) ? 25 : resultsTree.analysis.samplesByRow * 18;

        // Remove old columns
        var position, col;
        for (var idx=resultsTree.columnCount; idx> 1; idx-- )
        {
            col = resultsTree.getColumn(idx-1);
            if (col !== null)
            {
                resultsTree.removeColumn(idx-1);
            }
        }

        // Add columns
        var columns = analysis.displayedAnnotations;
        for (idx=0; idx < columns.length; idx++)
        {
            resultsTree.insertField(columns[idx], idx);
        }

        // Restore sort column indicator
        for (idx=0; idx<analysis.order.length; idx++)
        {
            var orderDirection = 0;
            var uid = analysis.order[idx];
            if (uid[0] == "-")
            {
                uid = uid.substr(1);
                orderDirection = 1;
            }

            resultsTree.sortIndicatorColumn = columns.indexOf(uid);
            resultsTree.sortIndicatorOrder = orderDirection;
        }

        resultsTree.resizeColumnsToContents();
    }


    function insertField(info, position, forceRefresh)
    {
        var col;


        if (info.uid === "_Samples")
        {
            col = columnComponent_Samples.createObject(resultsTree);
        }
        else if (info.uid === "_RowHead")
        {
            col = columnComponent_RowHead.createObject(resultsTree);
        }
        else
        {
            var annot = info.annotation;
            col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});

/*
            // Getting QML column according to the type of the fields
            if (annot.type == "int")
                col = columnComponent_number.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
            else if (annot.type == "bool")
                col = columnComponent_bool.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
            else if (annot.type == "sequence")
                col = columnComponent_sequence.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
            else if (annot.type == "list")
                col = columnComponent_list.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
            else if (annot.type == "sample_array")
            {
                if (annot.name == "Genotype")
                    col = columnComponent_SampleArrayGT.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                else if (annot.meta["type"] == "enum")
                    col = columnComponent_SampleArrayEnum.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                else
                    col = columnComponent_SampleArrayString.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
            }
            else
                col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
*/
        }

        //console.log("  display column " + uid + " at " + position);
        resultsTree.insertColumn(position, col);
    }
}

