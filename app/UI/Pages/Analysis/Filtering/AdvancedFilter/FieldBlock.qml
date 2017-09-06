import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"

Rectangle
{
    id: root
    height: Regovar.theme.font.boxSize.control
    implicitHeight: Regovar.theme.font.boxSize.control

    color: "transparent"

    property FilteringAnalysis analysis
    property var model
    property var opMapping: {"<":"<", "<=": "≤", "==": "=", ">=": "≥", ">": ">", "!=": "≠"}
    property var opMappingR: {"<":"<", "≤": "<=", "=": "==", "≥": ">=", ">": ">", "≠": "!="}

    onModelChanged: updateView()
    Component.onCompleted: updateView()
    onAnalysisChanged: updateView()

    function updateView()
    {
        if (model !== undefined && analysis !== null)
        {
            operator.text = opMapping[model[0]] ;
            leftOp.text = analysis.getColumnInfo(model[1][1]).annotation.name;
            rightOp.text = model[2][1];
        }
    }

    Rectangle
    {
        anchors.fill: parent
        color: "#aaaaaaaa"

        Row
        {
            anchors.fill: parent
            spacing: 5


            Text
            {
                id: leftOp
                text: "-"
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
            }
            Text
            {
                id: operator
                text: "?"
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
            }
            Text
            {
                id: rightOp
                text: "-"
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
            }
        }
    }
}
