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
        var t = model.quickfilters.qualityFilter
        var a = model.quickfilters.qualityFilter.depth
        var r = model.quickfilters.qualityFilter.depth.isActivated
        var e = model.quickfilters.qualityFilter.depth.op
        var z = model.quickfilters.qualityFilter.depth.value
    }

    content: RowLayout
    {
        anchors.left: root.left
        anchors.right: root.right
        spacing: 10


        CheckBox
        {
            text: qsTr("Depth")
            //checked: model.quickfilters.qualityFilter.isActivated
            //onCheckedChanged: model.quickfilters.qualityFilter.setFilter(0, checked)
        }
        ComboBox
        {
            width: 50
            model: [ "<", "<=", "==", ">=", ">", "!=" ]
            //currentText: model.quickfilters.qualityFilter.op
        }
        TextField
        {
            Layout.fillWidth: true
            //text: model.quickfilters.qualityFilter.value
        }
    }
}
