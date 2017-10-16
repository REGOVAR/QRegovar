import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../Regovar"
import "../../../Framework"
import "AdvancedFilter"
import "../../../Dialogs"

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
            }
        }


        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: Regovar.theme.primaryColor.back.light
        }


        ColumnLayout
        {
            width: root.width - 20

            spacing: 10
            Button
            {
                Layout.fillWidth: true
                text: qsTr("Apply filter")
                onClicked:
                {
                    model.results.applyFilter(model.advancedfilter.toJson());
                }
            }
            Button
            {
                Layout.fillWidth: true
                text: qsTr("Clear filter")
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
            console.log("AddNewCond from UUID : " + newCondLogicalGroupUuid + " " + conditionJson);
            advancedFilterEditor.update()
            advancedFilterEditor.model.addCondition(newCondLogicalGroupUuid, conditionJson);
        }
    }
    Connections
    {
        target: model
        onDisplayFilterNewCondPopup:
        {
            newCondLogicalGroupUuid = conditionUid;
            console.log("Saved UUID : " + newCondLogicalGroupUuid);
            filterNewCondPopup.open();
        }
    }
}
