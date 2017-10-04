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
            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top : parent.top
                text: "Ä"
                font.family: Regovar.theme.icons.name
                font.pixelSize: 30
                color: Regovar.theme.primaryColor.back.normal

                NumberAnimation on anchors.topMargin
                {
                    duration: 2000
                    loops: Animation.Infinite
                    from: 30
                    to: 0
                    easing.type: Easing.SineCurve
                }
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
			placeholderText: qsTr("Set field's value")
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
            fieldDescription.text = item.description;
            model.newConditionModel.setField(item.uid);
            operatorSelector.model = model.newConditionModel.opFieldList;
            operatorSelector.currentIndex = model.newConditionModel.opFieldIndex;
            displayInputControl(model.newConditionModel.fieldType);
        }
        else
        {
            displayInputControl("");
        }
    }

    function updateModel()
    {
        if (model)
        {
            model.newConditionModel.type = AdvancedFilterModel.FieldBlock;
            model.newConditionModel.opFieldIndex = operatorSelector.currentIndex;

            console.log("updateModel");
            console.log(" > opIdx = " + model.newConditionModel.opFieldIndex);
            console.log(" > " + model.newConditionModel.fieldType);
            if (model.newConditionModel.fieldType == "int")
            {
                console.log(" > (int)" + fieldInput.text);
                model.newConditionModel.fieldValue = parseInt(fieldInput.text, 10);
            }
            else if (model.newConditionModel.fieldType == "float")
            {
                console.log(" > (float)" + fieldInput.text);
                model.newConditionModel.fieldValue = parseFloat(fieldInput.text, 10);
            }
            else if (model.newConditionModel.fieldType == "bool")
            {
                console.log(" > (bool)" + fieldBoolInput.checked);
                model.newConditionModel.fieldValue = fieldBoolInput.checked;
            }
            else
            {
                console.log(" > (str)" + fieldInput.text);
                model.newConditionModel.fieldValue = fieldInput.text;
            }
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
}
