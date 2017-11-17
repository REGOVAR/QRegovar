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


    Component.onCompleted:
    {
        var maxSize = Math.max()
    }

    property int buttonSize: -1
    function setButtonSize(width, elmt)
    {

        buttonSize = Math.max(buttonSize, width);
        elmt.width = buttonSize;
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 10

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


        ButtonIcon
        {
            id: showButton
            anchors.margins: 10
            text: qsTr("Show selection")
            icon: "`"
            enabled: true
            onWidthChanged: root.setButtonSize(width, this)
        }

        ButtonIcon
        {
            id: exportButton
            anchors.margins: 10
            text: qsTr("Export")
            icon: "_"
            enabled: true
            onWidthChanged: root.setButtonSize(width, this)
        }

        ButtonIcon
        {
            id: reportButton
            anchors.margins: 10
            text: qsTr("Report")
            icon: "Y"
            enabled: true
            onWidthChanged: root.setButtonSize(width, this)
        }

        ButtonIcon
        {
            id: pipeButton
            anchors.margins: 10
            text: qsTr("Pipeline")
            icon: "I"
            enabled: false

            onWidthChanged: root.setButtonSize(width, this)
        }
        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
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
        var sf = ["AND", [["IN", ["filter", "" + filter.id ]]]];
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
