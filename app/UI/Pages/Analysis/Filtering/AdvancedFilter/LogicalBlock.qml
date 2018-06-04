import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

Rectangle
{
    id: root
    color: "transparent"

    property FilteringAnalysis analysis
    property AdvancedFilterModel model    
    property bool isExpand: true
    onIsExpandChanged: resize()
    Component.onCompleted: resize()

    // We don't use default qml enabled property to keep MouseArea available even when the
    // control is disabled
    property bool isEnabled: true

    property bool isFirst: false

    property string logicalColor: Regovar.theme.filtering.filterAND


    onModelChanged:
    {
        if (model)
        {
            model.filterChanged.connect(updateViewFromModel);
            updateViewFromModel();
        }
    }
    Component.onDestruction:
    {
        model.filterChanged.disconnect(updateViewFromModel);
    }

    function updateViewFromModel()
    {
        if (model)
        {
            // store index because update of the combo model will change the currentIndex and so the current model value
            var op = model.opList.indexOf(model.op);
            // update combo model
            operator.model = model.opList;
            // restore model current op
            operator.currentIndex = op;
        }
    }

    function updateModelFromView()
    {
        if (model && operator.model != -1) // check combobox model to avoid wrong indexChanged due to QML init
        {
            model.op = model.opList[operator.currentIndex];
        }
    }

    function fullSize()
    {
        var totalHeight = header.height + addConditionButton.height;
        for(var idx=0; idx < subItemsList.children.length; idx ++)
        {
            totalHeight += subItemsList.children[idx].height;
        }
        return totalHeight;
    }

    function resize()
    {
        root.height = isExpand ? fullSize() : header.height;
        console.log("resize height : " + root.height);
    }


    Rectangle
    {
        id: header
        height: Regovar.theme.font.boxSize.normal
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        color: "transparent"




        ComboBox
        {
            id: operator
            anchors.top: parent.top
            anchors.left: parent.left
            enabled: root.isEnabled
            color: root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
            onCurrentIndexChanged:
            {
                updateModelFromView();
                root.logicalColor = currentIndex == 0 ? Regovar.theme.filtering.filterAND : Regovar.theme.filtering.filterOR;
            }


        }

        Row
        {
            anchors.top: parent.top
            anchors.right: parent.right

            Text
            {
                text:  "|"  // "["
                height: Regovar.theme.font.boxSize.header
                width: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.normal
                font.family: Regovar.theme.icons.name
                rotation: (isExpand) ? 180 : 0
                visible: !isFirst

                Behavior on rotation {  NumberAnimation { duration: 200 } }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: isExpand = !isExpand
                    hoverEnabled: true
                    onEntered: parent.color = Regovar.theme.secondaryColor.back.normal
                    onExited: parent.color = Regovar.theme.primaryColor.back.normal
                    enabled: !isFirst

                }
            }
            Text
            {
                text: "h"
                height: Regovar.theme.font.boxSize.header
                width: Regovar.theme.font.boxSize.normal
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.normal
                font.family: Regovar.theme.icons.name

                ToolTip.text: isFirst ? qsTr("Clear filter") : qsTr("Remove group condition")
                ToolTip.delay: 1000
                ToolTip.visible: color == Regovar.theme.frontColor.danger

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: isFirst ? root.model.analysis.emitDisplayClearFilterPopup()  : root.model.removeCondition()
                    hoverEnabled: true
                    onEntered: parent.color = Regovar.theme.frontColor.danger
                    onExited: parent.color = Regovar.theme.primaryColor.back.normal
                }
            }
        }
    }



    Rectangle
    {
        visible: isExpand
        anchors.top : header.bottom
        anchors.left: parent.left
        anchors.leftMargin: Regovar.theme.font.boxSize.normal / 2
        height: subItemsList.height
        width: 1
        color: root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
    }

    Column
    {
        id: subItemsList
        visible: isExpand
        anchors.top : header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        onHeightChanged: { console.log("L height=" + height + " total="+fullSize()); resize(); }

        Repeater
        {
            id: repeater
            model: (root.model) ? root.model.subConditions : []


            Rectangle
            {
                anchors.left: parent.left
                anchors.right: parent.right
                height: Regovar.theme.font.boxSize.normal // This default size is overrided when the child GenericBlock height changed
                color: "transparent"

                id: logicalSubItem
                property bool isChecked
                onIsCheckedChanged: modelData.enabled = isChecked

                Rectangle
                {
                    height: Regovar.theme.font.boxSize.normal
                    width: Regovar.theme.font.boxSize.normal
                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: "transparent"

                    Text
                    {
                        anchors.centerIn: parent
                        text: "r"
                        font.family: Regovar.theme.icons.name
                        font.pixelSize: Regovar.theme.font.size.normal

                        color: Regovar.theme.backgroundColor.main
                    }
                    Text
                    {
                        anchors.centerIn: parent
                        text: "À"
                        font.family: Regovar.theme.icons.name
                        font.pixelSize: Regovar.theme.font.size.normal

                        color: root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
                    }
                    Text
                    {
                        anchors.centerIn: parent
                        visible: logicalSubItem.isChecked
                        text: "p"
                        font.family: Regovar.theme.icons.name
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Regovar.theme.font.size.small

                        color: root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: logicalSubItem.isChecked = !logicalSubItem.isChecked
                    }
                }

                GenericBlock
                {
                    analysis: root.analysis
                    model: modelData
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 5 + Regovar.theme.font.boxSize.normal
                    width: root.width - 5 - Regovar.theme.font.boxSize.normal
                    isEnabled: logicalSubItem.isChecked && root.isEnabled
                    onHeightChanged: { parent.height = height; resize(); }
                }
            }
        }
    }

    Rectangle
    {
        visible: isExpand

        id: addConditionButton
        property bool isHover: false

        height: Regovar.theme.font.boxSize.normal
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right

        color: "transparent"

        Rectangle
        {
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.leftMargin: Regovar.theme.font.boxSize.normal / 2
            width: 1
            height: parent.height/2
            color: root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
        }

        Rectangle
        {
            color: "transparent"
            anchors.top : parent.top
            anchors.left: parent.left
            height: Regovar.theme.font.boxSize.normal
            width: Regovar.theme.font.boxSize.normal

            Rectangle
            {
                anchors.centerIn: parent

                height: Regovar.theme.font.boxSize.normal * 0.75
                width: Regovar.theme.font.boxSize.normal * 0.75
                radius: width * 0.5

                color: addConditionButton.isHover ? Regovar.theme.secondaryColor.back.light : Regovar.theme.backgroundColor.main
                border.width: 1
                border.color: root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
            }
            Text
            {
                anchors.centerIn: parent
                text:  "à"
                color: addConditionButton.isHover ? Regovar.theme.secondaryColor.back.dark : root.isEnabled ? root.logicalColor : Regovar.theme.frontColor.disable
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.normal
            }
        }

        Text
        {
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.leftMargin: Regovar.theme.font.boxSize.normal + 5
            height: Regovar.theme.font.boxSize.normal
            text:  "Add condition"
            color: addConditionButton.isHover ? Regovar.theme.secondaryColor.back.dark : Regovar.theme.frontColor.disable

            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.normal
        }

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: addConditionButton.isHover = true
            onExited: addConditionButton.isHover = false
            onClicked: analysis.emitDisplayFilterNewCondPopup(model.qmlId)
        }
    }
}
