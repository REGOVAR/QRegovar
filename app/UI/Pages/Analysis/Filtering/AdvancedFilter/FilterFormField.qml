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
            text: qsTr("Operator")
        }
        ComboBox
        {
            id: operatorSelector
            Layout.fillWidth: true
            model: ["<", ">", "=", "!="]
        }

        Text
        {
            text: qsTr("Value")
        }
        TextField
        {
            id: fieldStringInput
            Layout.fillWidth: true
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
        }
        else
        {
            fieldDescription.text = "-";
        }
    }
}
