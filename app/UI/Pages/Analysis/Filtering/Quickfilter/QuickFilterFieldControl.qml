import QtQuick 2.7
import QtQuick.Layouts 1.3
import org.regovar 1.0

import "../../../../Regovar"
import "../../../../Framework"

RowLayout
{
    id: root
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 10

    property QuickFilterField model

    onModelChanged:
    {
        dpCheck.text = model.label;
        dpCheck.checked = Qt.binding(function() { return model.isActive; });
        dpOperator.model = model.opList;
        dpOperator.currentIndex = model.opList.indexOf(model.op);
        dpValue.text = Qt.binding(function() { return model.value; });
    }


    CheckBox
    {
        id: dpCheck
        anchors.left: parent.left
        anchors.leftMargin: 25
        width: 150
    }
    Binding { target: model; property: "isActive"; value: dpCheck.checked; }


    // FIXME : Weird bug, need to add free space otherwise ComboBox is hover the CheckBox
    Rectangle{ height: root.height; width: 10; color: "transparent"; }


    ComboBox
    {
        id: dpOperator
        onCurrentTextChanged: root.model.op = currentText
    }

    TextFieldForm
    {
        id: dpValue
        Layout.fillWidth: true
    }
    Binding { target: model; property: "value"; value: dpValue.text; }


    // FIXME : Qt BUG, margin value not take in account when control resize by the Splitter
    Rectangle{ height: root.height; width: 20; color: "transparent"; } // add 10+20px to the right (free space for scrollbar)
}
