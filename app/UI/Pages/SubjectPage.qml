import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import org.regovar 1.0


import "../Regovar"

Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main




    TreeView
    {
        anchors.fill: parent
        anchors.margins: 10
        model: theModel

        style: TreeViewStyle {
                branchDelegate: Rectangle {
                    width: 15; height: 15
                    color: styleData.isExpanded ? "red" : "green"
                }
            }



        // Default delegate for all column
        itemDelegate: Item
        {
            Text
            {
                anchors.fill: parent
                color: "green"
                text: styleData.row + ": " + styleData.column + " = " + styleData.value
            }
        }

        TableViewColumn {
            role: "name"
            title: "Name"

            // Deletegate for this column only
            delegate: Item
            {
                Text
                {
                    anchors.fill: parent
                    color: "red"
                    text: styleData.row + ": " + styleData.column + " = " + styleData.value
                }
            }
        }

        TableViewColumn {
            role: "date"
            title: "Date"

            delegate: Item
            {
                Text
                {
                    anchors.fill: parent
                    color: Regovar.theme.frontColor.normal
                    text: styleData.row + ": " + styleData.column + " = " + styleData.value
                }
            }
        }

        TableViewColumn {
            role: "comment"
            title: "Comment"
        }
    }
}

