import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"

Rectangle
{
    id: root
    color: "transparent"

    property FilteringAnalysis analysis
    property bool isChecked: true
    property var model
    property var subItems
    property bool isExpand: true
    onIsExpandChanged: resize()


    property string logicalColor: Regovar.theme.filtering.filterAND

    onModelChanged: updateView()
    onAnalysisChanged: updateView()
    Component.onCompleted: updateView()


    function updateView()
    {
        if (model != null && analysis != null)
        {
            root.subItems = model[1];
            operator.currentIndex = model[0] === "AND" ? 0 : 1;
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
        height: Regovar.theme.font.boxSize.control
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        color: "transparent"

        ComboBox
        {
            id: operator
            anchors.top: parent.top
            anchors.left: parent.left
            enabled: root.isChecked
            model: ["AND", "OR"]
            color: root.isChecked ? root.logicalColor : Regovar.theme.frontColor.disable
            onCurrentIndexChanged:
            {
                root.logicalColor = currentIndex == 0 ? Regovar.theme.filtering.filterAND : Regovar.theme.filtering.filterOR;
            }


        }

        Text
        {
            anchors.top: parent.top
            anchors.right: parent.right
            text: "|"
            height: Regovar.theme.font.boxSize.header
            width: Regovar.theme.font.boxSize.header
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Regovar.theme.font.size.header
            // color: loadFilterButton.mouseHover ? Regovar.theme.secondaryColor.back.normal : Regovar.theme.primaryColor.back.normal
            font.family: Regovar.theme.icons.name

            MouseArea
            {
                anchors.fill: parent
                onClicked: isExpand = !isExpand
            }
        }
    }



    Rectangle
    {
        visible: isExpand
        anchors.top : header.bottom
        anchors.left: parent.left
        anchors.leftMargin: Regovar.theme.font.boxSize.control / 2
        height: subItemsList.height
        width: 1
        color: root.isChecked ? root.logicalColor : Regovar.theme.frontColor.disable
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
            model:root.subItems


            Rectangle
            {
                anchors.left: parent.left
                anchors.right: parent.right
                height: Regovar.theme.font.boxSize.control // This default size is overrided when the child GenericBlock height changed
                color: "transparent"

                id: logicalSubItem
                property bool isChecked: true

                Rectangle
                {
                    height: Regovar.theme.font.boxSize.control
                    width: Regovar.theme.font.boxSize.control
                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: "transparent"

                    Text
                    {
                        anchors.centerIn: parent
                        text: "r"
                        font.family: Regovar.theme.icons.name
                        font.pixelSize: Regovar.theme.font.size.control

                        color: Regovar.theme.backgroundColor.main
                    }
                    Text
                    {
                        anchors.centerIn: parent
                        text: "²"
                        font.family: Regovar.theme.icons.name
                        font.pixelSize: Regovar.theme.font.size.control

                        color: root.isChecked ? root.logicalColor : Regovar.theme.frontColor.disable
                    }
                    Text
                    {
                        anchors.centerIn: parent
                        visible: logicalSubItem.isChecked
                        text: "p"
                        font.family: Regovar.theme.icons.name
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Regovar.theme.font.size.content

                        color: root.logicalColor
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
                    anchors.leftMargin: 5 + Regovar.theme.font.boxSize.control
                    width: root.width - 5 - Regovar.theme.font.boxSize.control
                    isChecked: logicalSubItem.isChecked

                    onHeightChanged: { parent.height = height; console.log("z height=" + height + " total="+fullSize()); resize(); }
                }
            }
        }
    }

    Rectangle
    {
        visible: isExpand

        id: addConditionButton
        property bool isHover: false

        height: Regovar.theme.font.boxSize.control
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right

        color: "transparent"

        Rectangle
        {
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.leftMargin: Regovar.theme.font.boxSize.control / 2
            width: 1
            height: parent.height/2
            color: root.isChecked ? root.logicalColor : Regovar.theme.frontColor.disable
        }

        Rectangle
        {
            color: "transparent"
            anchors.top : parent.top
            anchors.left: parent.left
            height: Regovar.theme.font.boxSize.control
            width: Regovar.theme.font.boxSize.control

            Rectangle
            {
                anchors.centerIn: parent

                height: Regovar.theme.font.boxSize.control * 0.75
                width: Regovar.theme.font.boxSize.control * 0.75
                radius: width * 0.5

                color: addConditionButton.isHover ? Regovar.theme.secondaryColor.back.light : Regovar.theme.backgroundColor.main
                border.width: 1
                border.color: root.isChecked ? root.logicalColor : Regovar.theme.frontColor.disable
            }
            Text
            {
                anchors.centerIn: parent
                text:  "µ"
                color: addConditionButton.isHover ? Regovar.theme.secondaryColor.back.dark : root.isChecked ? root.logicalColor : Regovar.theme.frontColor.disable
                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.control
            }
        }

        Text
        {
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
            height: Regovar.theme.font.boxSize.control
            text:  "Add condition"
            color: addConditionButton.isHover ? Regovar.theme.secondaryColor.back.dark : Regovar.theme.frontColor.disable

            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.control
        }

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: addConditionButton.isHover = true
            onExited: addConditionButton.isHover = false
            onClicked: analysis.emitDisplayFilterNewCondPopup(root.model)
        }
    }
}
