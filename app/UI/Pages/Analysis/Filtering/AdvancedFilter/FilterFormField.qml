import QtQuick 2.7
import QtQuick.Layouts 1.3
import org.regovar 1.0


import "../../../../Regovar"
import "../../../../Framework"


Rectangle
{
    id: root
    color: Regovar.theme.backgroundColor.main
    property FilteringAnalysis model
    onModelChanged:
    {
        if (model)
        {
            fieldSelector.model = model.annotationsFlatList;
        }
    }
    onZChanged:
    {
        if (z == 100)
        {
            updateModel();
        }
    }



    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text
        {
            Layout.fillWidth: true
            text: qsTr("Simple condition on a specific variant's annotation field. Allowed operator may change according to the type of field.")
            wrapMode: Text.WordWrap
        }

        Text
        {
            text: qsTr("Field")
        }

        AutoCompleteTextField
        {
            id: fieldSelector
            Layout.fillWidth: true
            placeholderText: "Search fied"
            onSelectedItemChanged: updateFilterControls()
        }
        Text
        {
            id: fieldDescription
            text: "-"
            Layout.minimumHeight: 2 * Regovar.theme.font.size.content
            font.pixelSize: Regovar.theme.font.size.content
            wrapMode: Text.WordWrap
            color: Regovar.theme.primaryColor.back.normal
            Layout.fillWidth: true
        }

        Text
        {
            id: operatorLabel
            text: qsTr("Operator")
        }
        ComboBox
        {
            id: operatorSelector
            Layout.fillWidth: true

        }

        Text
        {
            id: valueLabel
            text: qsTr("Value")

        }
        TextField
        {
            id: fieldStringInput
            Layout.fillWidth: true
            text: "-"
            visible: false
        }
        TextField
        {
            id: fieldIntInput
            Layout.fillWidth: true
            text: "-"
            inputMethodHints: Qt.ImhDigitsOnly
            visible: false
        }
        TextField
        {
            id: fieldRealInput
            Layout.fillWidth: true
            text: "-"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            visible: false
        }
        TextField
        {
            id: fieldSequenceInput
            Layout.fillWidth: true
            text: "-"
            inputMethodHints: Qt.ImhUppercaseOnly
            visible: false
        }
        Switch
        {
            id: fieldBoolInput
            checked: true
            text: checked ? qsTr("Yes") : qsTr("No")
        }


        Rectangle
        {
            color: "transparent"
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


    Rectangle
    {
        height: 1
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.right: root.right
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        width: 1
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.top: root.top
        color: Regovar.theme.boxColor.border
    }
    Rectangle
    {
        width: 1
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.top: root.top
        color: Regovar.theme.boxColor.border
    }



    function updateFilterControls()
    {
        var item = fieldSelector.selectedItem;
        if (item)
        {
            fieldDescription.text = item.description;
            model.newConditionModel.setField(item.uid);
            operatorSelector.model = model.newConditionModel.opFieldList
            operatorSelector.currentIndex = model.newConditionModel.opFieldIndex;
            if (model.newConditionModel.fieldType == "int")
            {
                displayInputControl(fieldIntInput);
            }
            else if (model.newConditionModel.fieldType == "float")
            {
                displayInputControl(fieldRealInput);
            }
            else if (model.newConditionModel.fieldType == "bool")
            {
                displayInputControl(fieldBoolInput);
            }
            else if (model.newConditionModel.fieldType == "sequence")
            {
                displayInputControl(fieldSequenceInput);
            }
            else
            {
                displayInputControl(fieldStringInput);
            }

            // TODO : hidde/display element according to the type of field
        }
        else
        {
            fieldDescription.text = "-";
        }
    }

    function updateModel()
    {
        if (model)
        {
            model.newConditionModel.type = AdvancedFilterModel.FieldBlock;
            model.newConditionModel.opFieldIndex = operatorSelector.currentIndex;
            if (model.newConditionModel.fieldType == "int")
            {
                model.newConditionModel.fieldValue = parseInt(fieldStringInput.text, 10);
            }
            else if (model.newConditionModel.fieldType == "float")
            {
                model.newConditionModel.fieldValue = parseFloat(fieldStringInput.text);
            }
            else if (model.newConditionModel.fieldType == "bool")
            {
                model.newConditionModel.fieldValue = fieldBoolInput.checked;
            }
            else if (model.newConditionModel.fieldType == "sequence")
            {
                model.newConditionModel.fieldValue = fieldSequenceInput.text;
            }
            else
            {
                model.newConditionModel.fieldValue = fieldStringInput.text;
            }
        }
    }

    function displayInputControl(control)
    {
        fieldBoolInput.visible = false;
        fieldSequenceInput.visible = false;
        fieldRealInput.visible = false;
        fieldIntInput.visible = false;
        fieldStringInput.visible = false;

        control.visible = true;

        if (control === fieldBoolInput)
        {
            operatorLabel.visible = false;
            operatorSelector.visible = false;
            valueLabel.visible = false;
        }
        else
        {
            operatorLabel.visible = true;
            operatorSelector.visible = true;
            valueLabel.visible = true;
        }
    }

}
