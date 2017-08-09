import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"


QuickFilterBox
{
    id: root
    title : qsTr("Quality")
    isEnabled : false
    isExpanded: false

    Component.onCompleted:
    {
        var t = regovar.currentFilteringAnalysis.quickfilters.qualityFilter
        var a = regovar.currentFilteringAnalysis.quickfilters.qualityFilter.depth
        var r = regovar.currentFilteringAnalysis.quickfilters.qualityFilter.depth.isActivated
        var e = regovar.currentFilteringAnalysis.quickfilters.qualityFilter.depth.op
        var z = regovar.currentFilteringAnalysis.quickfilters.qualityFilter.depth.value
    }

    content: RowLayout
    {
        anchors.left: root.left
        anchors.right: root.right
        spacing: 10


        CheckBox
        {
            text: qsTr("Depth")
            //checked: regovar.currentFilteringAnalysis.quickfilters.qualityFilter.isActivated
            //onCheckedChanged: regovar.currentFilteringAnalysis.quickfilters.qualityFilter.setFilter(0, checked)
        }
        ComboBox
        {
            width: 50
            model: [ "<", "<=", "==", ">=", ">", "!=" ]
            //currentText: regovar.currentFilteringAnalysis.quickfilters.qualityFilter.op
        }
        TextField
        {
            Layout.fillWidth: true
            //text: regovar.currentFilteringAnalysis.quickfilters.qualityFilter.value
        }
    }
}
