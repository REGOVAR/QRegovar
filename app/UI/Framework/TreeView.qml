import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "../Regovar"


TreeView
{
    id: control


    property var currentItem
    property int rowHeight: Regovar.theme.font.boxSize.normal

    signal headerResized(var headerPosition, var newSize)
    signal headerMoved(var oldPosition, var newPosition)

    style: TreeViewStyle
    {
        frame: Rectangle
        {
            color: Regovar.theme.boxColor.back
            border.width: 1
            border.color: Regovar.theme.boxColor.border
        }

        rowDelegate: Rectangle
        {
            height: control.rowHeight
            color:  styleData.hasActiveFocus ? Regovar.theme.secondaryColor.back.light :
                    (
                        styleData.selected ? Regovar.theme.secondaryColor.back.light :
                        (
                            styleData.alternate ? Regovar.theme.boxColor.back : Regovar.theme.backgroundColor.main
                        )
                    )
        }

        headerDelegate:  Item
        {
            id: headerRoot
            height: 24
            Component.onCompleted: formerPosition = position

            // Manage user changing position of header
            property int formerPosition: 0
            property int position: styleData.column
            property bool myPressed: styleData.pressed
            onMyPressedChanged:
            {
                if (!myPressed)
                {
                    if (formerPosition != position)
                    {
                        headerMoved(formerPosition, position);
                        formerPosition = position;
                    }
                }
            }

            // Manage user changing size of header
            onWidthChanged:
            {
                if (visible && width >= 0)
                {
                    headerResized(styleData.column, width);
                }
            }

            // Design
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
            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                // Label
                Text
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.familly
                    color: Regovar.theme.frontColor.normal
                    horizontalAlignment: styleData.textAlignment
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    text: styleData.value
                }

                // Sorting indicator
                Text
                {
                    Layout.fillHeight: true
                    visible: control.sortIndicatorVisible && control.sortIndicatorColumn == headerRoot.position
                    width: control.sortIndicatorVisible && control.sortIndicatorColumn == headerRoot.position ? Regovar.theme.font.boxSize.normal : 0
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.icons.name
                    color: Regovar.theme.frontColor.normal
                    horizontalAlignment: styleData.textAlignment
                    verticalAlignment: Text.AlignVCenter
                    text: control.sortIndicatorOrder == 0 ? "|" : "["
                }
            }
        }

        branchDelegate: Text
        {
            anchors.leftMargin: 5

            font.pixelSize: 16 // Regovar.theme.font.size.normal
            text: styleData.isExpanded ? "[" : "{"
            font.family: Regovar.theme.icons.name
            visible: styleData.hasChildren
            enabled: styleData.hasChildren
        }
    }

    // Default delegate for all column
    itemDelegate: Item
    {
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
    }

    onDoubleClicked: isExpanded(index) ? collapse(index) : expand(index)


}

