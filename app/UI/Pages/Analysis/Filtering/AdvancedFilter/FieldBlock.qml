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
    property AdvancedFilterModel model
    property bool isChecked: true

//    onModelChanged: updateView()
//    Component.onCompleted: updateView()
//    onAnalysisChanged: updateView()

//    function updateView()
//    {
//        if (model !== undefined && analysis !== null)
//        {
//            operator.text = opMapping[model[0]] ;
//            leftOp.text = analysis.getColumnInfo(model[1][1]).annotation.name;
//            rightOp.text = model[2][1];
//        }
//    }

    Rectangle
    {
        anchors.fill: parent
        color: "transparent"

        Row
        {
            anchors.fill: parent
            spacing: 5


            Text
            {
                id: leftOp
                text: model.leftOp
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                color: root.isChecked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
            }
            Text
            {
                id: operator
                text: model.op
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                color: root.isChecked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
            }
            Text
            {
                id: rightOp
                text: model.rightOp
                height: Regovar.theme.font.boxSize.control
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Regovar.theme.font.size.control
                color: root.isChecked ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.disable
            }
        }
    }
}
