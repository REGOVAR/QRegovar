import QtQuick 2.7
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main

    property FilteringAnalysis model
    onModelChanged:
    {
        model.newConditionModel.resetWizard.connect(function()
        {
            andCond.checked = true;
        });
    }

    onZChanged:
    {
        if (z == 100)
        {
            updateModelFromView();
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text
        {
            Layout.fillWidth: true
            text: qsTr("Add a logical group : \"AND\" or \"OR\" that will be applied to sub conditions wrapped by the logical group.")
            wrapMode: Text.WordWrap
        }

        Text
        {
            text: qsTr("Condition")
        }
        Row
        {
            Layout.fillWidth: true
            spacing: 10

            CheckBox
            {
                id: andCond
                text: qsTr("AND")
                checked: true
                onCheckedChanged: orCond.checked = !checked
                width: 100
            }
            CheckBox
            {
                id: orCond
                text: qsTr("OR")
                checked: false
                onCheckedChanged: andCond.checked = !checked
                width: 100
            }
        }

        Rectangle
        {
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


    Rectangle
    {
        height: 1
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.right: root.right
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        width: 1
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.top: root.top
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        width: 1
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.top: root.top
        color: Regovar.theme.boxColor.border
    }

    function updateModelFromView()
    {
        if (model)
        {
            model.newConditionModel.type =  AdvancedFilterModel.LogicalBlock;
            model.newConditionModel.op = andCond.checked ? "AND" : "OR";
        }
    }
}
