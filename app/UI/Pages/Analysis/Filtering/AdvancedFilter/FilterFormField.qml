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
            currentIndex: 0
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
            text: (model) ? model.newConditionModel.fieldValue : "-"
        }
        // fieldRealInput
        // fieldIntInput
        // fieldEnumInput

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
            model.newConditionModel.fieldUid = item.uid;
            operatorSelector.model = model.newConditionModel.opList;
            operatorSelector.currentIndex = 0;
            fieldStringInput.text = "";
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
			// force reload of the field informations

            model.newConditionModel.opIndex = operatorSelector.currentIndex;
            model.newConditionModel.fieldValue = fieldStringInput.text;
        }
    }
}
