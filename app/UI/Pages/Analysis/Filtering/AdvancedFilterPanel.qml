import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "../../../Dialogs"
import "AdvancedFilter"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        if (model)
        {
            advancedFilterEditor.analysis = model;
            advancedFilterEditor.model = model.advancedfilter;
        }
    }
    onZChanged:
    {
        if (model && model.advancedfilter.forceRefresh)
        {
            advancedFilterEditor.update();
            model.advancedfilter.forceRefresh = false;
        }
    }

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

                text: qsTr("Advanced filter")
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
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            LogicalBlock
            {
                id:advancedFilterEditor
                x: 5
                y: 5
                width: root.width - 10
                isFirst: true
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
                text: qsTr("Apply filter")
                iconTxt: "x"
                onClicked:
                {
                    model.results.applyFilter(model.advancedfilter.toJson());
                    // Update Title
                    root.model.currentFilterName = "";
                }
            }
            ButtonIcon
            {
                id: saveButton
                anchors.top: parent.top
                anchors.left: applyButton.right
                anchors.margins: 10
                text: qsTr("Save filter")
                iconTxt: "5"
                enabled: model && model.currentFilterName == ""
                onClicked:
                {
                    model.emitDisplayFilterSavingFormPopup();
                }
            }
        }
    }

    property string newCondLogicalGroupUuid: ""
    FilterNewConditionDialog
    {
        id: filterNewCondPopup;
        model: root.model
        onAddNewCondition:
        {
            // Update filter
            advancedFilterEditor.update()
            advancedFilterEditor.model.addCondition(newCondLogicalGroupUuid, conditionJson);
            // Update Title
            root.model.currentFilterName = "";
        }

        onVisibleChanged: root.model.newConditionModel.emitResetWizard();
    }
    Connections
    {
        target: model
        onDisplayFilterNewCondPopup:
        {
            newCondLogicalGroupUuid = conditionUid;
            filterNewCondPopup.open();
        }
    }

    QuestionDialog
    {
        id: clearFilterPopup
        title: qsTr("Clear filter confiration")
        text: qsTr("Do you wants to clear all filter's conditions ?")
        onYes:
        {
            // Update filter
            model.loadFilter(["AND", []]);
            advancedFilterEditor.update();
            // Update Title
            root.model.currentFilterName = "";
        }
    }
    Connections
    {
        target: model
        onDisplayClearFilterPopup:
        {
            clearFilterPopup.open();
        }
    }
}
