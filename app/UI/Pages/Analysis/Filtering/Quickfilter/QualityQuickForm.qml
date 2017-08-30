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

    onModelChanged:
    {
        depth.model = model.quickfilters.qualityFilter.depth;
    }

    content: QuickFilterFieldControl
    {
        id: depth

        anchors.left: parent.left
        anchors.right: parent.right
//        spacing: 10

//        // FIXME : Qt BUG : margin value not take in account when control resize by the Splitter
//        Rectangle{ height: root.height; width: 0; color: "transparent"; } // add 10px margin to the left

//        CheckBox
//        {
//            id: dpCheck
//            anchors.left: parent.left
//            anchors.leftMargin: 25
//            width: 150
//            text: qsTr("Depth")
//            checked: model.quickfilters.qualityFilter.depth.isActive
//        }
//        Binding
//        {
//            target: model.quickfilters.qualityFilter.depth
//            property: "isActive"
//            value: dpCheck.checked
//        }

//        // FIXME : Strange bug, need to add free space otherwise ComboBox is hover the CheckBox
//        Rectangle{ height: root.height; width: 0; color: "transparent"; }

//        ComboBox
//        {
//            id: dpOperator
//            model: [ "<", "≤", "=", "≥", ">", "≠" ]
//            currentIndex: 3
//            onCurrentTextChanged: root.model.quickfilters.qualityFilter.depth.op = currentText
//        }

//        TextFieldForm
//        {
//            id: dpValue
//            Layout.fillWidth: true
//            text: (model !== undefined) ? model.quickfilters.qualityFilter.depth.value : 100
//        }
//        Binding
//        {
//            target: model.quickfilters.qualityFilter.depth
//            property: "value"
//            value: dpValue.text
//        }

//        // FIXME : Qt BUG : margin value not take in account when control resize by the Splitter
//        Rectangle{ height: root.height; width: 20; color: "transparent"; } // add 10+20px to the right (free space for scrollbar)
    }
}
