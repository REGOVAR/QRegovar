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
    border.width: 1
    border.color: "purple"

    property FilteringAnalysis analysis
    property var model
    property var subItems
    property bool isExpand: true
    onIsExpandChanged: { console.log("Expand " + isExpand + " " + root.height); resize();}

    property string logicalColor: "red" // Regovar.theme.boxColor.border

    onModelChanged: updateView()
    onAnalysisChanged: updateView()
    Component.onCompleted: updateView()





    Rectangle
    {
        id: header
        height: Regovar.theme.font.boxSize.control
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#aaaaaaaa"

        ComboBox
        {
            id: operator
            anchors.top: parent.top
            anchors.left: parent.left
            model: ["AND", "OR"]

            color: root.logicalColor
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
        anchors.top : parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: Regovar.theme.font.boxSize.header / 2
        height: subItemsList.height
        width: 1
        color: root.logicalColor
    }

    Column
    {
        id: subItemsList
        visible: isExpand
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        onHeightChanged: { console.log("L height=" + height + " total="+fullSize()); resize(); }

        Repeater
        {
            model:root.subItems


            GenericBlock
            {
                analysis: root.analysis
                model: modelData
                width: subItemsList.width

                color: "brown"
                logicalColor: root.logicalColor
                border.width: 2
                border.color: "black"

                onHeightChanged: { parent.height = height; console.log("z height=" + height + " total="+fullSize()); resize(); }
                Component.onCompleted: { parent.height = height; console.log("c height=" + height + " total="+fullSize());}
            }

        }
    }

    Rectangle
    {
        visible: isExpand

        id: addConditionButton
        height: Regovar.theme.font.boxSize.control
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        color: "yellow"

        Rectangle
        {
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.leftMargin: Regovar.theme.font.boxSize.control / 2
            width: 1
            height: parent.height/2
            color: root.logicalColor
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

                color: Regovar.theme.backgroundColor.main
                border.width: 1
                border.color: root.logicalColor
            }
            Text
            {
                anchors.centerIn: parent
                text:  "µ"

                font.family: Regovar.theme.icons.name
                font.pixelSize: Regovar.theme.font.size.control
            }
        }

        Text
        {
            anchors.top : parent.top
            anchors.bottom : parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: Regovar.theme.font.boxSize.control + 5
            height: Regovar.theme.font.boxSize.header
            text:  "Add condition"

            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Regovar.theme.font.size.control
        }


    }


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

}
