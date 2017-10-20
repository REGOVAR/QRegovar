import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import "../Regovar"

TableView
{
    id: root

    alternatingRowColors: true

    property int navMode: 1 // 0=None, 1=Row, 2=Col, 3=Cell

    property int rowHeight: Regovar.theme.font.boxSize.normal

    property int currentColumn: 0
    property int selectedColumn: 0

    Keys.onRightPressed:
        if (currentColumn < root.columnCount - 1)
            currentColumn++;

    Keys.onLeftPressed:
        if (currentColumn > 0)
            currentColumn--;
    Keys.onUpPressed:
        if (currentRow < root.currentRow - 1)
            currentRow++;

    Keys.onDownPressed:
        if (currentRow > 0)
            currentRow--;


    style: TableViewStyle
    {
        activateItemOnSingleClick: true
        backgroundColor: Regovar.theme.backgroundColor.main
        alternateBackgroundColor: Regovar.theme.backgroundColor.alt
        //highlightedTextColor: Regovar.theme.secondaryColor.front.light
        textColor: Regovar.theme.frontColor.normal
        frame: Rectangle
        {
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
        }
    }

    function getBgColor(row, column, alt)
    {
        if (root.navMode == 0) return "transparent";

        // Hovered
        if (root.navMode == 1 && row == root.currentRow)
            return Regovar.theme.secondaryColor.back.light;

        // Selected
        if (root.navMode == 1 && root.selection.contains(row))
            return Regovar.theme.secondaryColor.back.normal;

        return alt ? Regovar.theme.boxColor.back : Regovar.theme.backgroundColor.main
    }

    // Default delegate for all column
    itemDelegate: Item
    {
        id: tableItem
        property bool selected: styleData.row === root.currentRow && styleData.column === currentColumn
        property bool hovered: false


        Text
        {
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: styleData.textAlignment
            font.pixelSize: Regovar.theme.font.size.normal
            text: (styleData.value !== undefined && styleData.value !== null) ? styleData.value : "" // + " (" + styleData.row + "," + styleData.column + ")"
            elide: Text.ElideRight
        }

        MouseArea
        {
            anchors.fill: parent
            propagateComposedEvents: true
            hoverEnabled: true
            onEntered: update(true)
            onExited: update(false)
            onClicked: root.forceActiveFocus();

            function update(hover)
            {
                tableItem.hovered = hover;
                root.currentColumn = styleData.column;
                root.currentRow = styleData.row;
            }
        }
    }

    rowDelegate: Rectangle
    {
        height: root.rowHeight
        color:  root.enabled ? getBgColor(styleData.row, styleData.column, styleData.alternate) : "transparent"
    }



    headerDelegate: Rectangle
    {
        id: headerRoot
        height: 24
        border.width: 0

        border.color: Regovar.theme.boxColor.border


        LinearGradient
        {
            anchors.fill: parent
            anchors.margins: 1
            start: Qt.point(0, 0)
            end: Qt.point(0, 24)
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: Regovar.theme.boxColor.header1  }
                GradientStop { position: 1.0; color: Regovar.theme.boxColor.header2  }
            }
        }

        // Right border
        Rectangle
        {
            width: 1
            anchors.top: headerRoot.top
            anchors.right: headerRoot.right
            anchors.bottom: headerRoot.bottom
            color: Regovar.theme.boxColor.border
        }
        // Top border
        Rectangle
        {
            height: 1
            anchors.left: headerRoot.left
            anchors.right: headerRoot.right
            anchors.top: headerRoot.top
            color: Regovar.theme.boxColor.border
        }
        // Bottom border
        Rectangle
        {
            height: 1
            anchors.left: headerRoot.left
            anchors.right: headerRoot.right
            anchors.bottom: headerRoot.bottom
            color: Regovar.theme.boxColor.border
        }

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            font.pixelSize: Regovar.theme.font.size.normal
            font.family: Regovar.theme.font.familly
            color: Regovar.theme.frontColor.normal
            horizontalAlignment: styleData.textAlignment
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            text: styleData.value
        }
    }


}
