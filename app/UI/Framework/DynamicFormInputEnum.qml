import QtQuick 2.9
import QtQuick.Layouts 1.3
import Regovar.Core 1.0

import "../Regovar"


GridLayout
{
    id: root
    columnSpacing: 10
    rowSpacing: 5
    columns: 3
    rows: 2

    property DynamicFormFieldModel model
    onModelChanged:
    {
        if (model)
        {
            model.form.onLabelWidthChanged.connect(function() { label.Layout.minimumWidth = model.form.labelWidth; } );
            model.onDataChanged.connect(updateViewFromModel);
            updateViewFromModel();
            model.validate();
        }
    }

    function updateViewFromModel()
    {
        //input.text = model.value;
        input.color =  model.error ? Regovar.theme.frontColor.normal : Regovar.theme.frontColor.danger;
        errorMessage.text = model.error ? model.errorMessage : "";
    }

    Text
    {
        id: label
        elide: Text.ElideRight
        font.pixelSize: Regovar.theme.font.size.normal
        color: Regovar.theme.primaryColor.back.dark
        text: root.model ? root.model.title + (root.model.required ? " *" : "")  : "?"
        onWidthChanged: model.form.labelWidth = Math.max(model.form.labelWidth, width)
        font.bold: root.model.required
    }

    IconButton
    {
        tooltip: model.description
    }

    ComboBox
    {
        id: input
        Layout.fillWidth: true
        model: root.model ? root.model.enumValues : ["?"]
        onModelChanged: if (root.model && root.model.defaultValue) input.currentIndex = root.model.defaultValue
        onCurrentIndexChanged: if (root.model) root.model.value = input.currentIndex
    }

    Text
    {
        id: errorMessage
        Layout.row: 1
        Layout.column: 2
        Layout.fillWidth: true
        text: ""
        font.pixelSize: Regovar.theme.font.size.small
        font.italic: true
        color: Regovar.theme.frontColor.danger
        wrapMode: Text.WordWrap
    }
}
