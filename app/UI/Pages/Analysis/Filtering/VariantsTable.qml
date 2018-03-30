import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import Regovar.Core 1.0
import QtQml.Models 2.2

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"
import "qrc:/qml/MainMenu"
import "qrc:/qml/InformationPanel/Variant"

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
    //onHeaderResized: analysis.saveHeaderWidth(headerPosition, newSize)



    MouseArea
    {
        anchors.fill: parent
        anchors.topMargin: Regovar.theme.font.boxSize.normal // = Header height (see UI/Framework/TreeView.qml)

        acceptedButtons: Qt.RightButton
        onClicked:resultsTree.openVariantInfoDialog(mouse.x, mouse.y + Regovar.theme.font.boxSize.normal) // compense header's margin
    }


    // Generic Column component use to display new one when user select a new annotation
    Component
    {
        id: columnComponent
        TableViewColumn { width: 100 }
    }

    // Icon formating
    Component
    {
        id: columnComponent_icon
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
                    horizontalAlignment: styleData.textAlignment
                    font.pixelSize: Regovar.theme.font.size.header
                    text: styleData.value ? styleData.value.toString() : ""
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.primaryColor.back.normal
                }
            }
        }
    }

    // NoWrap formating
    Component
    {
        id: columnComponent_nowrap
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
                    horizontalAlignment: styleData.textAlignment
                    font.pixelSize: Regovar.theme.font.size.normal
                    text: styleData.value ? styleData.value.toString() : ""
                    elide: Text.ElideRight
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

            delegate: Item
            {
                CheckBox
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    checked: Boolean(styleData.value)
                    text: "" // resultsTree.model.data(styleData.index, Qt.UserRole +1)
                    onClicked:
                    {
                        var id = resultsTree.model.data(styleData.index, Qt.UserRole +1);
                        resultsTree.checked(id, checked);
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
            title: qsTr("Samples")
            width: 70

            delegate: Item
            {
                Text
                {
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    font.pixelSize: Regovar.theme.font.size.normal
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    color: Regovar.theme.frontColor.disable
                    text : analysis.results.samplesNames
                }
            }
        }
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

        resultsTree.rowHeight = (resultsTree.analysis.samplesByRow === 1) ? Regovar.theme.font.boxSize.normal : resultsTree.analysis.samplesByRow * Regovar.theme.font.boxSize.normal;

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
            // col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});

            // Getting QML column according to the type of the fields
            if (annot.type == "bool")
                col = columnComponent_icon.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});
            else if (annot.type == "sample_array")
            {
                if (annot.name == "Genotype")
                    col = columnComponent_icon.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
                else
                    col = columnComponent_nowrap.createObject(resultsTree, {"role": annot.uid, "title": annot.name});
            }
            else
                col = columnComponent.createObject(resultsTree, {"role": annot.uid, "title": annot.name, "width": info.width});

        }

        //console.log("  display column " + uid + " at " + position);
        resultsTree.insertColumn(position, col);
    }
}

