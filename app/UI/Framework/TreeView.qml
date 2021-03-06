import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "qrc:/qml/Regovar"


TreeView
{
    id: control


    property var currentItem
    property int rowHeight: Regovar.theme.font.boxSize.normal

    signal headerResized(var headerPosition, var newSize)
    signal headerMoved(var oldPosition, var newPosition)

    // cacheBuffer: 100
    //maximumFlickVelocity: 1

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
                        styleData.selected ? Regovar.theme.secondaryColor.back.light : "transparent"
//                        (
//                            styleData.alternate ? Regovar.theme.boxColor.back : Regovar.theme.backgroundColor.main
//                        )
                    )
        }

        headerDelegate:  Item
        {
            id: headerRoot
            height: Regovar.theme.font.boxSize.header
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
//            onWidthChanged:
//            {
//                if (visible && width >= 0)
//                {
//                    headerResized(styleData.column, width);
//                }
//            }

            Rectangle
            {
                anchors.fill: parent
                color: Regovar.theme.boxColor.back // Regovar.theme.darker(Regovar.theme.boxColor.back, 1.1) // Regovar.theme.backgroundColor.alt
            }

            // Right border
            Rectangle
            {
                width: 1
                anchors.top: headerRoot.top
                anchors.right: headerRoot.right
                anchors.bottom: headerRoot.bottom
                anchors.topMargin: 5
                anchors.bottomMargin: 5
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
                anchors.fill: headerRoot
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                // Label
                Text
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    font.pixelSize: Regovar.theme.font.size.normal
                    font.family: Regovar.theme.font.family
                    color: Regovar.theme.primaryColor.back.normal
                    horizontalAlignment: styleData.textAlignment
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    text: styleData.value
                    font.bold: true
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
            text: styleData.value ? styleData.value.toString() : ""
            elide: Text.ElideRight
            renderType: Text.NativeRendering
            textFormat: Text.PlainText
            wrapMode: Text.WrapAnywhere
        }
    }

    onDoubleClicked: isExpanded(index) ? collapse(index) : expand(index)


}

