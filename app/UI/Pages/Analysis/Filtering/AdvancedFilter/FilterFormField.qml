import QtQuick 2.9
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
            model.newConditionModel.resetWizard.connect(function()
            {
                fieldSelector.selectedItem = null;
                fieldSelector.text = "";
                updateFilterControls();
            });
        }
    }
    onZChanged:
    {
        if (z == 100)
        {
            updateModelFromView();
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
            placeholder: "Search fied"
            onSelectedItemChanged: updateFilterControls()
        }
        Text
        {
            id: fieldDescription
            text: "-"
            Layout.minimumHeight: 2 * Regovar.theme.font.size.small
            font.pixelSize: Regovar.theme.font.size.small
            wrapMode: Text.WordWrap
            color: Regovar.theme.primaryColor.back.normal
            Layout.fillWidth: true
            visible: false
        }

        Rectangle
        {
            id: helpPanel

            color: "transparent"
            height: 100
            Layout.fillWidth: true

			Text
            {
                text: qsTr("Select a field first.")
                font.pixelSize: Regovar.theme.font.size.header
                color: Regovar.theme.primaryColor.back.normal
                anchors.fill: parent
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }

        Text
        {
            id: operatorLabel
            text: qsTr("Operator")
            visible: false
        }
        ComboBox
        {
            id: operatorSelector
            Layout.fillWidth: true
            visible: false

        }

        Text
        {
            id: valueLabel
            text: qsTr("Value")
            visible: false

        }

        TextField
        {
            id: fieldInput
            Layout.fillWidth: true
            visible: false
			placeholder: qsTr("Set field's value")
        }
        Switch
        {
            id: fieldBoolInput
            checked: true
            text: checked ? qsTr("Yes") : qsTr("No")
            visible: false
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
            model.newConditionModel.field = item;
            fieldDescription.text = item.description;
            var opModel = [];
            for (var i=0; i<model.newConditionModel.opList.length; i++)
            {
                var rego = model.newConditionModel.opList[i];
                var frnd = model.newConditionModel.opRegovarToFriend(rego);
                opModel = opModel.concat(frnd);
            }
            operatorSelector.model = opModel;
            operatorSelector.currentIndex = 0;
            displayInputControl(model.newConditionModel.fieldType);
        }
        else
        {
            displayInputControl("");
        }
    }
    function displayInputControl(type)
    {
        helpPanel.visible = false;
        fieldDescription.visible = false;
        operatorLabel.visible = false;
        operatorSelector.visible = false;
        valueLabel.visible = false;
        fieldInput.visible = false;
        fieldBoolInput.visible = false;

        if (type == "")
        {
            helpPanel.visible = true;
        }
        else if (type == "bool")
        {
            fieldDescription.visible = true;
            fieldBoolInput.visible = true;
        }
        else
        {
            fieldDescription.visible = true;
            operatorLabel.visible = true;
            operatorSelector.visible = true;
            valueLabel.visible = true;
            fieldInput.visible = true;
        }
    }

    function updateModelFromView()
    {
        if (model)
        {
            model.newConditionModel.type = AdvancedFilterModel.FieldBlock;
            model.newConditionModel.field = fieldSelector.selectedItem;
            if (model.newConditionModel.opList.length > 0)
            {
                model.newConditionModel.op = model.newConditionModel.opList[operatorSelector.currentIndex];
            }

            if (model.newConditionModel.field.type == "int")
            {
                model.newConditionModel.value = parseInt(fieldInput.text, 10);
            }
            else if (model.newConditionModel.field.type == "float")
            {
                model.newConditionModel.value = parseFloat(fieldInput.text, 10);
            }
            else if (model.newConditionModel.field.type == "bool")
            {
                model.newConditionModel.op = "==";
                model.newConditionModel.value = fieldBoolInput.checked;
            }
            else
            {
                model.newConditionModel.value = fieldInput.text;
            }
        }
    }


}
