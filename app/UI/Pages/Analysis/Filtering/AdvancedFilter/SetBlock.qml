import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"

Rectangle
{
    id: root
    width: parent.width
    height: Regovar.theme.font.boxSize.normal
    implicitHeight: Regovar.theme.font.boxSize.normal

    color: "transparent"

    property FilteringAnalysis analysis
    property bool isChecked: true
    property var model
    property var operator
    property var leftOp
    property var rightOp

    onModelChanged:
    {
        root.operator = model[0];
        root.leftOp = model[1];
        root.rightOp = model[2];
    }

    Rectangle
    {
        id: header
        width: parent.width
        height: Regovar.theme.font.boxSize.normal
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: 5

        Row
        {
            anchors.fill: parent
            spacing: 5


            Text
            {
                text: (root.leftOp !== null) ? root.leftOp[1] : ""
                font.pixelSize: Regovar.theme.font.size.normal
                color: root.isChecked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
            }
            Text
            {
                text: root.operator
                font.pixelSize: Regovar.theme.font.size.normal
                color: root.isChecked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
            }
            Text
            {
                text: (root.rightOp !== null) ? root.rightOp[1] : ""
                font.pixelSize: Regovar.theme.font.size.normal
                color: root.isChecked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
            }
        }
    }
}
