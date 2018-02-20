import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main
    property var iconMap: ({"sample": "4", "filter": "D", "attr": ";", "panel": "q"})
    property FilteringAnalysis model
    onModelChanged:
    {
        if (model)
        {
            model.newConditionModel.type = AdvancedFilterModel.SetBlock;
            var opModel = [];
            for (var i=0; i<model.newConditionModel.opList.length; i++)
            {
                var rego = model.newConditionModel.opList[i];
                var frnd = model.newConditionModel.opRegovarToFriend(rego);
                opModel = opModel.concat(frnd + " (" + (rego == "IN" ? qsTr("in the set") : qsTr("not in the set")) + ")");
            }
            operatorSelector.model = opModel;
            setSelector.model = model.sets;

            model.newConditionModel.resetWizard.connect(resetView);
        }
    }
    Component.onDestruction:
    {
        model.newConditionModel.resetWizard.disconnect(resetView);
    }
    onZChanged:
    {
        if (z == 100)
        {
            updateModelFromView();
        }
    }

    function resetView()
    {
        operatorSelector.currentIndex = 0;
        setSelector.currentIndex = 0;
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text
        {
            Layout.fillWidth: true
            text: qsTr("Filter by variant (chr-pos-ref-alt) or by site (chr-pos) that are (or not) in a specific set. Sets can be samples, saved filters or panels.")
            wrapMode: Text.WordWrap
        }


        Text
        {
            text: qsTr("Test for variants")
        }
        ComboBox
        {
            id: operatorSelector
            Layout.fillWidth: true
        }

        Text
        {
            text: qsTr("Set")
        }
        ComboBox
        {
            id: setSelector
            Layout.fillWidth: true
            editable: true


            delegate: ItemDelegate
            {
                x: 1
                width: setSelector.width-2
                height: Regovar.theme.font.boxSize.normal
                contentItem: RowLayout
                {
                    anchors.fill: parent
                    spacing: 5
                    Text
                    {
                        text: root.iconMap[modelData.type]
                        font.family: Regovar.theme.icons.name
                        color: Regovar.theme.boxColor.front
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: Regovar.theme.font.boxSize.normal
                        height: Regovar.theme.font.boxSize.normal
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Regovar.theme.boxColor.front
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        height: Regovar.theme.font.boxSize.normal
                    }
                }
                highlighted: setSelector.highlightedIndex === index
            }
            contentItem: RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: setSelector.indicator.width + setSelector.spacing
                spacing: 5
                Text
                {
                    text: (setSelector.model) ?  root.iconMap[setSelector.model[setSelector.currentIndex].type] : ""
                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.boxColor.front
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: Regovar.theme.font.boxSize.normal
                    height: Regovar.theme.font.boxSize.normal
                }
                Text
                {
                    Layout.fillWidth: true
                    text: (setSelector.model) ? setSelector.model[setSelector.currentIndex].label : ""
                    color: Regovar.theme.boxColor.front
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    height: Regovar.theme.font.boxSize.normal
                }
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
            model.newConditionModel.type = AdvancedFilterModel.SetBlock;
            model.newConditionModel.set = setSelector.model[setSelector.currentIndex];
            model.newConditionModel.op = model.newConditionModel.opList[operatorSelector.currentIndex];
        }
    }
}
