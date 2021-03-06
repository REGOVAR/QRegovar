import QtQuick 2.9
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "qrc:/qml/Regovar"
import "qrc:/qml/Framework"

RowLayout
{
    id: root
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 10

    property QuickFilterField model
    property bool initializing: false
    property alias checkBox: fieldCheck
    property alias checked: fieldCheck.checked
    property alias currentIndex: fieldOperator.currentIndex
    property real indentation: 25
    property real labelWidth: 50;
    onLabelWidthChanged:
    {
        fieldCheck.Layout.minimumWidth = labelWidth;
        //console.log(" > " + fieldCheck.width);
    }


    onModelChanged:
    {
        initializing = true;
        fieldCheck.text = model.label;
        fieldCheck.checked = Qt.binding(function() { return model.isActive; });
        var idx = model.opList.indexOf(model.op);
        fieldOperator.model = model.opList;
        fieldOperator.currentIndex = idx;
        fieldValue.text = Qt.binding(function() { return model.value; });
        initializing = false;
    }


    Item { height: 10; width: root.indentation - 10 }
    CheckBox
    {
        id: fieldCheck
        onWidthChanged: root.labelWidth = width;
        text: ""
    }
    //Binding { target: model; property: "isActive"; value: fieldCheck.checked; }


    // FIXME : Weird bug, need to add free space otherwise ComboBox is hover the CheckBox
    Rectangle{ height: root.height; width: 10; color: "transparent"; }


    ComboBox
    {
        id: fieldOperator
        onCurrentTextChanged:
        {
            if (root.model)
            {
                root.model.op = currentText;
                if (!initializing) fieldCheck.checked = true;
            }
        }

    }

    TextFieldForm
    {
        id: fieldValue
        Layout.fillWidth: true

        onTextEdited: fieldCheck.checked = true
        onTextChanged: fieldCheck.checked = true
        placeholderText: qsTr("Value ?")
    }
    //Binding { target: model; property: "value"; value: fieldValue.text; }


    // FIXME : Qt BUG, margin value not take in account when control resize by the Splitter
    Rectangle{ height: root.height; width: 20; color: "transparent"; } // add 10+20px to the right (free space for scrollbar)
}
