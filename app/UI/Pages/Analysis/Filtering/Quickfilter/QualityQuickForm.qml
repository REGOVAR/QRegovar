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


    content: RowLayout
    {
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins : 5
        anchors.rightMargin: 30
        spacing: 10


        CheckBox
        {
            anchors.left: parent.left
            anchors.leftMargin: 25
            width: 150
            text: qsTr("Depth")
            checked: false
            //checked: model.quickfilters.qualityFilter.isActivated
            //onCheckedChanged: model.quickfilters.qualityFilter.setFilter(0, checked)
        }
        ComboBox
        {
            model: [ "<", "≤", "=", "≥", ">", "≠" ] // [ "<", "<=", "==", ">=", ">", "!=" ]
            //currentText: model.quickfilters.qualityFilter.op
        }
        TextFieldForm
        {
            Layout.fillWidth: true
            //text: model.quickfilters.qualityFilter.value
        }
    }
}
